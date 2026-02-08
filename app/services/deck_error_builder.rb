class DeckErrorBuilder < ApplicationService
  def initialize(deck:)
    @deck = deck
  end

  def call(parse_errors: [], unmatched_cards: [])
    parse_errors.each do |error|
      create_error(error)
    end

    unmatched_cards.each do |card|
      create_error(
        line_number: card.fetch(:line_number),
        line_text: card.fetch(:line_text),
        error_code: "unmatched_card",
        message: "Card '#{card.fetch(:card_name)}' was not found in Scryfall"
      )
    end
  end

  private

  attr_reader :deck

  def create_error(payload)
    deck.deck_errors.create!(
      line_number: payload.fetch(:line_number),
      line_text: payload.fetch(:line_text),
      error_code: payload.fetch(:error_code),
      message: payload.fetch(:message)
    )
  end
end
