require "test_helper"

class DeckTest < ActiveSupport::TestCase
  test "generates share slug by default" do
    deck = Deck.new(
      commander_name: "Atraxa",
      theme_description: "Clockwork city",
      input_text: "1 Sol Ring"
    )

    assert deck.valid?
    assert_not_nil deck.share_slug
  end
end
