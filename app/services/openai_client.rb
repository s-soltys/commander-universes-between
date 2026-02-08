require "json"
require "net/http"
require "uri"

class OpenaiClient < ApplicationService
  RESPONSES_URL = URI("https://api.openai.com/v1/responses")

  def initialize(api_key: nil, model: nil, retries: 2)
    @api_key = api_key || ENV["OPENAI_API_KEY"] || Rails.application.credentials.dig(:openai, :api_key)
    @model = model || ENV.fetch("OPENAI_MODEL", "gpt-4.1-mini")
    @retries = retries
  end

  def generate_theme(original_name:, card_type:, theme_description:, commander_name:)
    return fallback_theme(original_name, card_type, theme_description) if api_key.blank?

    attempts = 0

    begin
      attempts += 1
      response = perform_request(prompt(original_name, card_type, theme_description, commander_name))
      parse_response(response, original_name, card_type, theme_description)
    rescue StandardError
      retry if attempts <= retries

      fallback_theme(original_name, card_type, theme_description)
    end
  end

  private

  attr_reader :api_key, :model, :retries

  def perform_request(prompt_text)
    request = Net::HTTP::Post.new(RESPONSES_URL)
    request["Authorization"] = "Bearer #{api_key}"
    request["Content-Type"] = "application/json"

    request.body = {
      model: model,
      input: prompt_text
    }.to_json

    Net::HTTP.start(RESPONSES_URL.host, RESPONSES_URL.port, use_ssl: true) do |http|
      http.read_timeout = 30
      http.open_timeout = 5
      http.request(request)
    end
  end

  def parse_response(http_response, original_name, card_type, theme_description)
    return fallback_theme(original_name, card_type, theme_description) unless http_response.is_a?(Net::HTTPSuccess)

    body = JSON.parse(http_response.body)
    output_text = body["output_text"].to_s.strip
    return fallback_theme(original_name, card_type, theme_description) if output_text.empty?

    lines = output_text.lines.map(&:strip).reject(&:empty?)
    themed_name = lines.first&.sub(/\Aname:\s*/i, "")
    art_description = lines.drop(1).join(" ").sub(/\Aart:\s*/i, "")

    {
      themed_name: themed_name.presence || "#{original_name} of #{theme_description.truncate(40)}",
      art_description: art_description.presence || "A #{card_type} card reimagined in #{theme_description}."
    }
  rescue JSON::ParserError
    fallback_theme(original_name, card_type, theme_description)
  end

  def prompt(original_name, card_type, theme_description, commander_name)
    <<~PROMPT
      Create a themed Commander card adaptation.
      Commander: #{commander_name}
      Theme: #{theme_description}
      Original card: #{original_name}
      Card type: #{card_type}

      Return two lines exactly:
      Name: <short themed name>
      Art: <single sentence art description>
    PROMPT
  end

  def fallback_theme(original_name, card_type, theme_description)
    {
      themed_name: "#{original_name} of #{theme_description.truncate(32)}",
      art_description: "A #{card_type.presence || 'mystic'} card reinterpreted through #{theme_description}."
    }
  end
end
