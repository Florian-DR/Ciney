require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "shows precise field errors next to an invalid team-building inquiry" do
    post team_building_inquiries_path, params: {
      team_building_inquiry: {
        company: "Atelier Condroz",
        contact_name: "Marie Dupont",
        email: "adresse incorrecte",
        telephone: "+32 470 12 34 56",
        participants: 101,
        desired_dates: "Septembre",
        package: "inconnue",
        message: "Court",
        website: "",
      },
    }

    assert_response :unprocessable_entity
    assert_select ".team-building-form-errors", text: /Corrigez les champs/
    assert_select ".team-building-form__field-errors", text: /adresse e-mail valide/
    assert_select ".team-building-form__field-errors", text: /dépasser 100/
    assert_select "input[aria-invalid='true']"
  end

  test "offers direct email contact when form protection rejects a request" do
    rejection = FormSubmissionGuard::Result.new(
      success?: false,
      message: "La vérification anti-spam n’a pas pu être validée.",
    )
    guard = Object.new
    guard.define_singleton_method(:call) { rejection }

    FormSubmissionGuard.stub(:new, ->(**_arguments) { guard }) do
      post team_building_inquiries_path, params: {
        team_building_inquiry: valid_inquiry_params,
      }
    end

    assert_response :unprocessable_entity
    assert_select ".team-building-form-errors", text: /vérification anti-spam/
    assert_select(
      ".team-building-form-errors a[href='mailto:#{ENV.fetch('GMAIL_ADDRESS')}']",
      text: ENV.fetch("GMAIL_ADDRESS"),
    )
  end

  private

  def valid_inquiry_params
    {
      company: "Atelier Condroz",
      contact_name: "Marie Dupont",
      email: "marie@example.com",
      telephone: "+32 470 12 34 56",
      participants: 18,
      desired_dates: "Septembre 2026",
      package: "residential",
      message: "Nous souhaitons réunir notre équipe pendant deux jours.",
      website: "",
    }
  end
end
