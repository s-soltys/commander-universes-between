class DeckError < ApplicationRecord
  belongs_to :deck

  validates :line_number, numericality: { only_integer: true, greater_than: 0 }
  validates :line_text, presence: true
  validates :error_code, presence: true
  validates :message, presence: true
end
