require "json"
require "net/http"
require "uri"

class ScryfallClient < ApplicationService
  BASE_URL = "https://api.scryfall.com"

  def initialize(sleep_interval: 0.11, user_agent: nil)
    @sleep_interval = sleep_interval
    @user_agent = user_agent || ENV.fetch("SCRYFALL_USER_AGENT", "commander-universes-between/1.0")
    @mutex = Mutex.new
    @last_request_at = nil
  end

  def card_named(name)
    return nil if name.to_s.strip.empty?

    response = get("/cards/named", exact: name)
    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue StandardError
    nil
  end

  private

  attr_reader :sleep_interval, :user_agent

  def get(path, params = {})
    throttle!

    uri = URI.join(BASE_URL, path)
    uri.query = URI.encode_www_form(params) if params.any?

    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    request["User-Agent"] = user_agent

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.read_timeout = 10
      http.open_timeout = 5
      http.request(request)
    end
  end

  def throttle!
    @mutex.synchronize do
      if @last_request_at
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - @last_request_at
        wait_time = sleep_interval - elapsed
        sleep(wait_time) if wait_time.positive?
      end

      @last_request_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
