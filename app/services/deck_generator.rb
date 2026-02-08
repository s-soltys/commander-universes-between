class DeckGenerator < ApplicationService
  def initialize(deck:, parser: DeckListParser, scryfall_client: ScryfallClient.new, openai_client: OpenaiClient.new)
    @deck = deck
    @parser = parser
    @scryfall_client = scryfall_client
    @openai_client = openai_client
  end

  def call
    parsed = parser.call(input_text: deck.input_text)
    unmatched_cards = []

    DeckErrorBuilder.call(deck: deck, parse_errors: parsed[:errors])

    valid_cards = aggregate_cards(parsed[:cards])
    deck.deck_cards.destroy_all

    valid_cards.each do |card|
      reference = scryfall_client.card_named(card[:card_name])

      if reference.blank?
        unmatched_cards.concat(card[:source_lines])
        next
      end

      themed = openai_client.generate_theme(
        original_name: card[:card_name],
        card_type: reference["type_line"],
        theme_description: deck.theme_description,
        commander_name: deck.commander_name
      )

      deck.deck_cards.create!(
        original_name: card[:card_name],
        quantity: card[:quantity],
        card_type: reference["type_line"],
        themed_name: themed.fetch(:themed_name),
        art_description: themed.fetch(:art_description),
        image_url: themed[:image_url]
      )
    end

    DeckErrorBuilder.call(deck: deck, unmatched_cards: unmatched_cards)

    deck.share_slug = generate_share_slug if deck.share_slug.blank?
    deck.status = derive_status
    deck.save!
    deck
  rescue StandardError
    deck.update!(status: :failed)
    deck
  end

  private

  attr_reader :deck, :parser, :scryfall_client, :openai_client

  def aggregate_cards(cards)
    grouped = {}

    cards.each do |card|
      key = card[:card_name].downcase
      grouped[key] ||= {
        card_name: card[:card_name],
        quantity: 0,
        source_lines: []
      }
      grouped[key][:quantity] += card[:quantity]
      grouped[key][:source_lines] << {
        line_number: card[:line_number],
        line_text: card[:line_text],
        card_name: card[:card_name]
      }
    end

    grouped.values
  end

  def derive_status
    return :failed if deck.deck_cards.empty?
    return :partial if deck.deck_errors.exists?

    :complete
  end

  def generate_share_slug
    loop do
      slug = SecureRandom.alphanumeric(10).downcase
      return slug unless Deck.exists?(share_slug: slug)
    end
  end
end
