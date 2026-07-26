require "digest"

class FormSubmissionGuard
  IP_LIMIT = 5
  IDENTIFIER_LIMIT = 3
  WINDOW = 15.minutes

  Result = Struct.new(:success?, :message, keyword_init: true)

  def initialize(key:, token:, remote_ip:, identifier: nil, hostname:, action:)
    @key = key
    @token = token
    @remote_ip = remote_ip
    @identifier = identifier
    @hostname = hostname
    @action = action
  end

  def call
    return rate_limit_failure unless within_rate_limit?("ip", @remote_ip, IP_LIMIT)
    return rate_limit_failure unless within_rate_limit?("identifier", normalized_identifier, IDENTIFIER_LIMIT)

    verification = Turnstile::Verifier.new(
      token: @token,
      remote_ip: @remote_ip,
      hostname: @hostname,
      action: @action,
    ).call

    return Result.new(success?: true) if verification.success?

    Rails.logger.info("Protected form rejected by Turnstile: #{verification.error_codes.join(',')}")
    failure("La vérification anti-spam n’a pas pu être validée. Actualisez la page puis réessayez. Si le problème persiste, contactez-nous directement sur notre adresse email ou par téléphone.")
  end

  private

  def within_rate_limit?(scope, value, limit)
    return true if value.blank?

    digest = Digest::SHA256.hexdigest(value.to_s)
    cache_key = "protected-form:#{@key}:#{scope}:#{digest}"
    count = Rails.cache.increment(cache_key, 1, expires_in: WINDOW)

    if count.nil?
      Rails.cache.write(cache_key, 1, expires_in: WINDOW)
      count = 1
    end

    count <= limit
  end

  def normalized_identifier
    @identifier.to_s.strip.downcase
  end

  def rate_limit_failure
    failure("Cette demande ne peut pas être envoyée pour le moment en raison d’un trop grand nombre de tentatives. Si le problème persiste, contactez-nous directement sur notre adresse email ou par téléphone")
  end

  def failure(message)
    Result.new(success?: false, message: message)
  end
end
