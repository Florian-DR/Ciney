require "test_helper"

class CineyMailerTest < ActionMailer::TestCase
  test "sends one shared team-building confirmation to the visitor and the farm" do
    message = CineyMailer.with(inquiry: inquiry_payload)
      .team_building_inquiry_mailer

    assert_equal ["marie@example.com"], message.to
    assert_equal [ENV.fetch("GMAIL_ADDRESS")], message.bcc
    assert_equal [ENV.fetch("GMAIL_ADDRESS")], message.from
    assert_nil message.reply_to
    assert_equal(
      "Votre projet team building à la Ferme d’Auwez – Atelier Condroz",
      message.subject,
    )
  end

  test "provides equivalent html and text content with a small inline logo" do
    message = CineyMailer.with(inquiry: inquiry_payload).team_building_inquiry_mailer
    html = message.html_part.body.decoded
    text = message.text_part.body.decoded
    logo = message.attachments.fetch(0)

    assert_includes html, "Demande bien reçue"
    assert_includes html, "Atelier Condroz"
    assert_includes text, "Votre demande de team building est bien arrivée"
    assert_includes text, "Atelier Condroz"
    assert_equal "logo-ferme-dauwez.png", logo.filename
    assert_equal "image/png", logo.mime_type
    assert_predicate logo, :inline?
    assert_operator logo.body.decoded.bytesize, :<, 50.kilobytes
  end

  test "escapes visitor-provided html in the message body" do
    payload = inquiry_payload.merge("message" => "<script>alert('spam')</script>")
    message = CineyMailer.with(inquiry: payload).team_building_inquiry_mailer
    html = message.html_part.body.decoded

    assert_not_includes html, "<script>"
    assert_includes html, "&lt;script&gt;"
  end

  private

  def inquiry_payload
    {
      "company" => "Atelier Condroz",
      "contact_name" => "Marie Dupont",
      "email" => "marie@example.com",
      "telephone" => "+32 470 12 34 56",
      "participants" => 18,
      "desired_dates" => "Septembre 2026",
      "package" => "residential",
      "message" => "Nous souhaitons réunir notre équipe pendant deux jours.",
    }
  end
end
