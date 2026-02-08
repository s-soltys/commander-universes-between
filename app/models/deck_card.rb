class DeckCard < ApplicationRecord
  belongs_to :deck

  validates :original_name, presence: true
  validates :themed_name, presence: true
  validates :art_description, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
