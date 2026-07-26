require "json"
require "net/http"

module Turnstile
  VERIFY_URL = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")
  TEST_SITE_KEY = "1x00000000000000000000AA"
  TEST_SECRET_KEY = "1x0000000000000000000000000000000AA"

  Result = Struct.new(:success?, :error_codes, keyword_init: true)

  def self.site_key
    ENV["TURNSTILE_SITE_KEY"].presence || (TEST_SITE_KEY unless Rails.env.production?)
  end

  def self.secret_key
    ENV["TURNSTILE_SECRET_KEY"].presence || (TEST_SECRET_KEY unless Rails.env.production?)
  end

  class Verifier
    def initialize(token:, remote_ip:, hostname:, action:)
      @token = token.to_s
      @remote_ip = remote_ip
      @hostname = hostname
      @action = action
    end

    def call
      return failure("missing-configuration") if Turnstile.secret_key.blank?
      return failure("missing-input-response") if @token.blank? || @token.length > 2_048

      response = verify_token
      payload = JSON.parse(response.body)
      valid_context = context_matches?(payload)

      Result.new(
        success?: response.is_a?(Net::HTTPSuccess) && payload["success"] == true && valid_context,
        error_codes: Array(payload["error-codes"]),
      )
    rescue JSON::ParserError, Net::OpenTimeout, Net::ReadTimeout, SocketError, SystemCallError => error
      Rails.logger.warn("Turnstile verification unavailable: #{error.class}")
      failure("verification-unavailable")
    end

    private

    def verify_token
      request = Net::HTTP::Post.new(Turnstile::VERIFY_URL)
      request.set_form_data(
        secret: Turnstile.secret_key,
        response: @token,
        remoteip: @remote_ip,
      )

      Net::HTTP.start(
        Turnstile::VERIFY_URL.hostname,
        Turnstile::VERIFY_URL.port,
        use_ssl: true,
        open_timeout: 3,
        read_timeout: 5,
      ) { |http| http.request(request) }
    end

    def context_matches?(payload)
      return true unless Rails.env.production?

      payload["action"] == @action &&
        payload["hostname"].present? &&
        ActiveSupport::SecurityUtils.secure_compare(payload["hostname"], @hostname)
    end

    def failure(code)
      Result.new(success?: false, error_codes: [code])
    end
  end
end
