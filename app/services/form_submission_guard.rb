require "digest"

class FormSubmissionGuard
  LIMIT = 5
  WINDOW = 15.minutes

  Result = Struct.new(:success?, :message, keyword_init: true)

  def initialize(key:, token:, remote_ip:, hostname:, action:)
    @key = key
    @token = token
    @remote_ip = remote_ip
    @hostname = hostname
    @action = action
  end

  def call
    return failure("Trop de tentatives ont été effectuées. Réessayez dans quelques minutes.") unless within_rate_limit?

    verification = Turnstile::Verifier.new(
      token: @token,
      remote_ip: @remote_ip,
      hostname: @hostname,
      action: @action,
    ).call

    return Result.new(success?: true) if verification.success?

    Rails.logger.info("Protected form rejected by Turnstile: #{verification.error_codes.join(',')}")
    failure("La vérification anti-spam a échoué. Actualisez la page et réessayez.")
  end

  private

  def within_rate_limit?
    digest = Digest::SHA256.hexdigest(@remote_ip.to_s)
    cache_key = "protected-form:#{@key}:#{digest}"
    count = Rails.cache.increment(cache_key, 1, expires_in: WINDOW)

    if count.nil?
      Rails.cache.write(cache_key, 1, expires_in: WINDOW)
      count = 1
    end

    count <= LIMIT
  end

  def failure(message)
    Result.new(success?: false, message: message)
  end
end
