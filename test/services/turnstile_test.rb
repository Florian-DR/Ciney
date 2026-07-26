require "test_helper"

class TurnstileTest < ActiveSupport::TestCase
  test "refuse un jeton absent sans appeler le service Cloudflare" do
    result = verifier(token: "").call

    assert_not result.success?
    assert_equal ["missing-input-response"], result.error_codes
  end

  test "accepte une réponse Cloudflare réussie en dehors de la production" do
    subject = verifier
    response = http_response(
      success: true,
      action: "autre-action",
      hostname: "autre-domaine.example",
    )

    result = subject.stub(:verify_token, response) { subject.call }

    assert result.success?,
      "En développement et en test, le contexte est ignoré pour permettre les clés de test Cloudflare"
  end

  test "vérifie en production que l’action et le domaine correspondent à la demande" do
    subject = verifier
    matching_response = http_response(
      success: true,
      action: "team_building_inquiry",
      hostname: "www.fermedauwez.be",
    )
    wrong_action_response = http_response(
      success: true,
      action: "contact",
      hostname: "www.fermedauwez.be",
    )

    Rails.env.stub(:production?, true) do
      Turnstile.stub(:secret_key, Turnstile::TEST_SECRET_KEY) do
        accepted = subject.stub(:verify_token, matching_response) { subject.call }
        rejected = subject.stub(:verify_token, wrong_action_response) { subject.call }

        assert accepted.success?
        assert_not rejected.success?,
          "Un jeton créé pour une autre action ne doit pas pouvoir être réutilisé"
      end
    end
  end

  test "transforme une réponse illisible en échec contrôlé" do
    subject = verifier
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@read, true)
    response.instance_variable_set(:@body, "pas du JSON")

    result = subject.stub(:verify_token, response) { subject.call }

    assert_not result.success?
    assert_equal ["verification-unavailable"], result.error_codes
  end

  test "transforme une indisponibilité réseau en échec contrôlé" do
    subject = verifier
    result = subject.stub(:verify_token, -> { raise Net::ReadTimeout }) { subject.call }

    assert_not result.success?
    assert_equal ["verification-unavailable"], result.error_codes
  end

  private

  def verifier(token: "jeton-valide")
    Turnstile::Verifier.new(
      token: token,
      remote_ip: "192.0.2.1",
      hostname: "www.fermedauwez.be",
      action: "team_building_inquiry",
    )
  end

  def http_response(payload)
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@read, true)
    response.instance_variable_set(:@body, payload.to_json)
    response
  end
end
