require "test_helper"

class DecksControllerTest < ActionDispatch::IntegrationTest
  test "creates deck with invalid payload returns bad request" do
    post "/decks", as: :json, params: { commander_name: "", theme_description: "", deck_list_text: "" }

    assert_response :bad_request
  end

  test "shows missing deck as not found" do
    get "/decks/does-not-exist", as: :json

    assert_response :not_found
  end
end
