class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact contact_sender about activities team_buildings team_building_inquiry sitemap]
  skip_before_action :all_gites, only: %i[home sitemap]

  def home
    # One query for the gites and one for all associated photos, also reused by
    # the navbar and footer.
    @gites = Gite.includes(:photos).order(:id).to_a
    @nav_gites = @gites

    @gite_1 = @gites.first
    @gite_2 = @gites.second
    @gite_3 = @gites.third
    @gite_4 = @gites.fourth
    @gite_5 = @gites.fifth
  end

  def admin
    # The navigation query already contains the id and name needed by this page.
    @gites = @nav_gites
  end

  def contact; end

  def contact_sender
    if params[:url].empty?
      CineyMailer.with(
                      name: params[:name],
                      first_name: params[:first_name],
                      email: params[:email], 
                      telephone: params[:telephone], 
                      message: params[:message]).contact_mailer.deliver_now
    end
    redirect_to contact_path 
    flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
  end

  def about; end

  def activities
    @gpx_trace_groups = ActivityCatalog::GPX_TRACE_GROUPS
  end

  def team_buildings
    @team_building_inquiry = TeamBuildingInquiry.new
  end

  def team_building_inquiry
    @team_building_inquiry = TeamBuildingInquiry.new(team_building_inquiry_params)

    if @team_building_inquiry.website.present?
      redirect_to team_buildings_path(anchor: "demande"), notice: team_building_success_message
      return
    end

    unless @team_building_inquiry.valid?
      render :team_buildings, status: :unprocessable_entity
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
      render :team_buildings, status: :unprocessable_entity
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
      render :team_buildings, status: :service_unavailable
      return
    end

    if turbo_frame_request?
      @team_building_form_success = team_building_success_message
      @team_building_inquiry = TeamBuildingInquiry.new
      render :team_buildings
    else
      redirect_to team_buildings_path(anchor: "demande"), notice: team_building_success_message
    end
  end

  def sitemap
    @sitemap_gites = Gite.select(:name, :updated_at).order(:id)
  end

  private

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
