Rails.configuration.x.openai_api_key = ENV["OPENAI_API_KEY"] || Rails.application.credentials.dig(:openai, :api_key)
Rails.configuration.x.scryfall_user_agent = ENV["SCRYFALL_USER_AGENT"] || Rails.application.credentials.dig(:scryfall, :user_agent)
