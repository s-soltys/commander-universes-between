require "test_helper"

class DeckListParserTest < ActiveSupport::TestCase
  test "parses valid deck lines" do
    result = DeckListParser.call(input_text: "2 Sol Ring\n1 Arcane Signet")

    assert_equal 2, result[:cards].size
    assert_empty result[:errors]
    assert_equal "Sol Ring", result[:cards].first[:card_name]
  end

  test "returns errors for invalid lines" do
    result = DeckListParser.call(input_text: "bad line\n0 Sol Ring")

    assert_empty result[:cards]
    assert_equal 2, result[:errors].size
    assert_equal "invalid_format", result[:errors].first[:error_code]
  end
end
