class DecksController < ApplicationController
  before_action :set_deck, only: [:show]

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(deck_attributes)

    unless @deck.save
      return render_invalid_input(@deck.errors.full_messages.to_sentence)
    end

    DeckGenerator.call(deck: @deck)

    respond_to do |format|
      format.html { redirect_to deck_path(@deck.share_slug), notice: "Deck generated." }
      format.json { render json: serialize_deck(@deck), status: :created }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: serialize_deck(@deck), status: :ok }
    end
  end

  private

  def set_deck
    @deck = Deck.includes(:deck_cards, :deck_errors).find_by(share_slug: params[:id]) || Deck.includes(:deck_cards, :deck_errors).find_by(id: params[:id])
    return if @deck

    respond_to do |format|
      format.html { render plain: "Not Found", status: :not_found }
      format.json { render json: { error: "Not found", details: "Deck not found" }, status: :not_found }
    end
  end

  def deck_attributes
    source = request.format.json? ? json_payload : html_payload

    {
      title: source[:title],
      commander_name: source[:commander_name],
      theme_description: source[:theme_description],
      input_text: source[:deck_list_text] || source[:input_text]
    }
  end

  def json_payload
    request.request_parameters.symbolize_keys
  end

  def html_payload
    params.fetch(:deck, {}).permit(:title, :commander_name, :theme_description, :input_text).to_h.symbolize_keys
  end

  def render_invalid_input(details)
    respond_to do |format|
      format.html do
        flash.now[:alert] = details
        render :new, status: :unprocessable_entity
      end
      format.json { render json: { error: "Invalid input", details: details }, status: :bad_request }
    end
  end

  def serialize_deck(deck)
    {
      id: deck.id.to_s,
      share_url: deck_url(deck.share_slug),
      status: deck.status,
      commander_name: deck.commander_name,
      theme_description: deck.theme_description,
      cards: deck.deck_cards.map do |card|
        {
          original_name: card.original_name,
          quantity: card.quantity,
          card_type: card.card_type,
          themed_name: card.themed_name,
          art_description: card.art_description,
          image_url: card.image_url
        }
      end,
      errors: deck.deck_errors.order(:line_number).map do |error|
        {
          line_number: error.line_number,
          line_text: error.line_text,
          error_code: error.error_code,
          message: error.message
        }
      end
    }
  end
end
