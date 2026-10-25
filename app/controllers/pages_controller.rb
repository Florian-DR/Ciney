class PagesController < ApplicationController
  HOME_GITE_NAMES = ["Les Hirondelles", "L'Horizon", "L'Arbre de Vie"].freeze

  skip_before_action :authenticate_user!, only: %i[home contact contact_sender about activities team_buildings team_building_inquiry domain sitemap]
  skip_before_action :all_gites, only: %i[home sitemap]

  def home
    # One query for the gites and one for all associated photos, also reused by
    # the navbar and footer.
    @gites = Gite.includes(:photos).order(:id).to_a
    @nav_gites = @gites
    gites_by_name = @gites.index_by(&:name)
    @home_gites = HOME_GITE_NAMES.filter_map { |name| gites_by_name[name] }
  end

  def admin
    # The navigation query already contains the id and name needed by this page.
    @gites = @nav_gites
  end

  def contact
    @contact_inquiry = ContactInquiry.new
  end

  def contact_sender
    @contact_inquiry = ContactInquiry.new(contact_inquiry_params)

    if @contact_inquiry.website.present?
      redirect_to contact_path(anchor: "demande"), notice: contact_success_message
      return
    end

    unless @contact_inquiry.valid?
      render :contact, formats: :html, status: :unprocessable_entity
      return
    end

    protection = FormSubmissionGuard.new(
      key: "contact",
      token: params["cf-turnstile-response"],
      remote_ip: request.remote_ip,
      identifier: @contact_inquiry.email,
      hostname: request.host,
      action: "contact_inquiry",
    ).call

    unless protection.success?
      @contact_form_error = protection.message
      render :contact, formats: :html, status: :unprocessable_entity
      return
    end

    begin
      CineyMailer.with(
        inquiry: @contact_inquiry.mailer_payload,
      ).contact_mailer.deliver_now
    rescue StandardError => error
      Rails.logger.error(
        "Contact inquiry email delivery failed: #{error.class}: #{error.message}",
      )
      @contact_form_error = "Un problème technique nous empêche d’envoyer votre demande pour le moment."
      render :contact, formats: :html, status: :service_unavailable
      return
    end

    if turbo_frame_request?
      @contact_form_success = contact_success_message
      @contact_inquiry = ContactInquiry.new
      render :contact, formats: :html
    else
      redirect_to contact_path(anchor: "demande"), notice: contact_success_message
    end
  end

  def about; end

  def activities
    @gpx_trace_groups = ActivityCatalog::GPX_TRACE_GROUPS
  end

  def team_buildings
    @team_building_inquiry = TeamBuildingInquiry.new
  end

  def domain
    render "gites/fifth_gite"
  end

  def team_building_inquiry
    @team_building_inquiry = TeamBuildingInquiry.new(team_building_inquiry_params)

    if @team_building_inquiry.website.present?
      redirect_to team_buildings_path(anchor: "demande"), notice: team_building_success_message
      return
    end

    unless @team_building_inquiry.valid?
      render :team_buildings, formats: :html, status: :unprocessable_entity
      return
    end

    protection = FormSubmissionGuard.new(
      key: "team-building",
      token: params["cf-turnstile-response"],
      remote_ip: request.remote_ip,
      identifier: @team_building_inquiry.email,
      hostname: request.host,
      action: "team_building_inquiry",
    ).call

    unless protection.success?
      @team_building_form_error = protection.message
      render :team_buildings, formats: :html, status: :unprocessable_entity
      return
    end

    begin
      CineyMailer.with(inquiry: @team_building_inquiry.mailer_payload)
        .team_building_inquiry_mailer
        .deliver_now
    rescue StandardError => error
      Rails.logger.error(
        "Team-building inquiry email delivery failed: #{error.class}: #{error.message}",
      )
      @team_building_form_error = "Un problème technique nous empêche d’envoyer votre demande pour le moment."
      render :team_buildings, formats: :html, status: :service_unavailable
      return
    end

    if turbo_frame_request?
      @team_building_form_success = team_building_success_message
      @team_building_inquiry = TeamBuildingInquiry.new
      render :team_buildings, formats: :html
    else
      redirect_to team_buildings_path(anchor: "demande"), notice: team_building_success_message
    end
  end

  def sitemap
    @sitemap_gites = Gite.where.not(name: "Toute la Ferme").select(:name, :updated_at).order(:id)
  end

  private

  def contact_inquiry_params
    params.require(:contact_inquiry).permit(
      :name,
      :first_name,
      :email,
      :telephone,
      :message,
      :website,
    )
  end

  def contact_success_message
    "Merci ! Votre message est bien arrivé. Un récapitulatif vous a été envoyé par e-mail."
  end

  def team_building_inquiry_params
    params.require(:team_building_inquiry).permit(
      :company,
      :contact_name,
      :email,
      :telephone,
      :participants,
      :desired_dates,
      :package,
      :message,
      :website,
    )
  end

  def team_building_success_message
    "Merci ! Votre projet est bien arrivé. Un récapitulatif vous a été envoyé par e-mail."
  end

end
