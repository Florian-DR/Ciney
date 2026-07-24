class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact contact_sender about]
  skip_before_action :all_gites, only: :home

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

end
