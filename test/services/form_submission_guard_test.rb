require "test_helper"

class FormSubmissionGuardTest < ActiveSupport::TestCase
  Verification = Struct.new(:success?, :error_codes, keyword_init: true)
  Verifier = Struct.new(:verification) do
    def call
      verification
    end
  end

  setup do
    @original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    @successful_verifier = Verifier.new(
      Verification.new(success?: true, error_codes: []),
    )
  end

  teardown do
    Rails.cache = @original_cache
  end

  test "limits repeated submissions to the same email address" do
    results = Turnstile::Verifier.stub(:new, verifier_factory) do
      4.times.map do |index|
        guard(remote_ip: "192.0.2.#{index}", identifier: " Marie@Example.com ").call
      end
    end

    assert results.first(3).all?(&:success?)
    assert_not results.last.success?
    assert_includes results.last.message, "Trop de tentatives"
  end

  test "limits repeated submissions from the same IP address" do
    results = Turnstile::Verifier.stub(:new, verifier_factory) do
      6.times.map do |index|
        guard(remote_ip: "192.0.2.10", identifier: "contact-#{index}@example.com").call
      end
    end

    assert results.first(5).all?(&:success?)
    assert_not results.last.success?
    assert_includes results.last.message, "Trop de tentatives"
  end

  private

  def verifier_factory
    ->(**_arguments) { @successful_verifier }
  end

  def guard(remote_ip:, identifier:)
    FormSubmissionGuard.new(
      key: "team-building-test",
      token: "valid-token",
      remote_ip: remote_ip,
      identifier: identifier,
      hostname: "www.fermedauwez.be",
      action: "team_building_inquiry",
    )
  end
end
