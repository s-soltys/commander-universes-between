class Deck < ApplicationRecord
  has_many :deck_cards, dependent: :destroy
  has_many :deck_errors, dependent: :destroy

  enum :status, {
    pending: "pending",
    complete: "complete",
    partial: "partial",
    failed: "failed"
  }, default: :pending

  validates :commander_name, presence: true
  validates :theme_description, presence: true
  validates :input_text, presence: true
  validates :share_slug, presence: true, uniqueness: true

  before_validation :ensure_share_slug

  private

  def ensure_share_slug
    return if share_slug.present?

    self.share_slug = SecureRandom.alphanumeric(10).downcase
  end
end
