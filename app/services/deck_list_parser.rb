class DeckListParser < ApplicationService
  LINE_PATTERN = /\A(\d+)\s+(.+)\z/

  def initialize(input_text:)
    @input_text = input_text.to_s
  end

  def call
    cards = []
    errors = []

    input_text.each_line.with_index(1) do |line, line_number|
      stripped = line.strip
      next if stripped.empty?

      match = stripped.match(LINE_PATTERN)
      unless match
        errors << parser_error(line_number, stripped, "invalid_format")
        next
      end

      quantity = match[1].to_i
      card_name = match[2].strip

      if quantity <= 0 || card_name.empty?
        errors << parser_error(line_number, stripped, "invalid_format")
        next
      end

      cards << {
        line_number: line_number,
        line_text: stripped,
        quantity: quantity,
        card_name: card_name
      }
    end

    { cards: cards, errors: errors }
  end

  private

  attr_reader :input_text

  def parser_error(line_number, line_text, code)
    {
      line_number: line_number,
      line_text: line_text,
      error_code: code,
      message: "Line #{line_number} must use the format: quantity + card name"
    }
  end
end
