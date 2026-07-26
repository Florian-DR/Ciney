require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  TURBO_FRAME_HEADERS = { "Turbo-Frame" => "team_building_inquiry" }.freeze

  test "uses server-side validation so inline errors can be displayed" do
    get team_buildings_path

    assert_response :success
    assert_select "turbo-frame#team_building_inquiry", count: 1
    assert_select(
      "form.team-building-form[novalidate][action='#{team_building_inquiries_path(anchor: 'demande')}']",
      count: 1,
    )
    assert_select(
      "[data-controller='turnstile'][data-turnstile-action-value='team_building_inquiry']",
      count: 1,
    )
  end

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
    }, headers: TURBO_FRAME_HEADERS

    assert_response :unprocessable_entity
    assert_select "turbo-frame#team_building_inquiry", count: 1
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
      }, headers: TURBO_FRAME_HEADERS
    end

    assert_response :unprocessable_entity
    assert_select ".team-building-form-errors", text: /vérification anti-spam/
    assert_select(
      ".team-building-form-errors a[href='mailto:#{ENV.fetch('GMAIL_ADDRESS')}']",
      text: ENV.fetch("GMAIL_ADDRESS"),
    )
  end

  test "returns an in-frame success without navigating away from the page" do
    success = FormSubmissionGuard::Result.new(success?: true)
    guard = Object.new
    guard.define_singleton_method(:call) { success }

    FormSubmissionGuard.stub(:new, ->(**_arguments) { guard }) do
      assert_emails 1 do
        post team_building_inquiries_path, params: {
          team_building_inquiry: valid_inquiry_params,
        }, headers: TURBO_FRAME_HEADERS
      end
    end

    assert_response :success
    assert_select "turbo-frame#team_building_inquiry" do
      assert_select ".team-building-form-success", text: /récapitulatif/
      assert_select "input[name='team_building_inquiry[company]'][value='Atelier Condroz']", count: 0
    end
  end

  test "ignore silencieusement un robot qui remplit le champ piège et n’envoie aucun e-mail" do
    params = valid_inquiry_params.merge(website: "https://spam.example")

    assert_no_emails do
      post team_building_inquiries_path, params: {
        team_building_inquiry: params,
      }
    end

    assert_redirected_to team_buildings_path(anchor: "demande")
    assert_includes flash[:notice], "Votre projet est bien arrivé"
  end

  test "affiche une erreur et l’adresse directe quand l’envoi de l’e-mail échoue" do
    success = FormSubmissionGuard::Result.new(success?: true)
    guard = Object.new
    guard.define_singleton_method(:call) { success }
    failing_mail = Object.new
    failing_mail.define_singleton_method(:team_building_inquiry_mailer) { self }
    failing_mail.define_singleton_method(:deliver_now) { raise Net::SMTPFatalError, "refus SMTP" }

    FormSubmissionGuard.stub(:new, ->(**_arguments) { guard }) do
      CineyMailer.stub(:with, failing_mail) do
        post team_building_inquiries_path, params: {
          team_building_inquiry: valid_inquiry_params,
        }, headers: TURBO_FRAME_HEADERS
      end
    end

    assert_response :service_unavailable
    assert_select ".team-building-form-errors", text: /problème technique/
    assert_select(
      ".team-building-form-errors a[href='mailto:#{ENV.fetch('GMAIL_ADDRESS')}']",
      text: ENV.fetch("GMAIL_ADDRESS"),
    )
  end

  test "redirige après un envoi classique pour éviter un second envoi au rechargement" do
    success = FormSubmissionGuard::Result.new(success?: true)
    guard = Object.new
    guard.define_singleton_method(:call) { success }

    FormSubmissionGuard.stub(:new, ->(**_arguments) { guard }) do
      assert_emails 1 do
        post team_building_inquiries_path, params: {
          team_building_inquiry: valid_inquiry_params,
        }
      end
    end

    assert_redirected_to team_buildings_path(anchor: "demande")
    assert_includes flash[:notice], "récapitulatif"
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
