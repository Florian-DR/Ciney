class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact contact_sender]
  def home
    @home = HomePage.first
    # raise
    @gites = Gite.all.order(:id)
    photos = @home.entreprises_photos.each_with_index.select { |photo, index| index > 0 && index < 5 }
    @entreprises_photos = photos.map(&:first)
    photos = @home.decouvrir_photos.each_with_index.select { |photo, index| index > 0 && index < 5 }
    @decouvrir_photos = photos.map(&:first)
  end

  def admin
    @saisons = Saison.all
    @saison = Saison.new
    
    @gites = Gite.all.order(:id)
    
    @days_of_week = DaysOfWeek.new
    @gite_holidays = GiteHoliday.new
    
    @holidays = Holiday.all
    @holiday = Holiday.new

    @charges = Charge.all
    @charge = Charge.new
  end

  def contact; end

  def contact_sender
    CineyMailer.with(
                    name: params[:name],
                    first_name: params[:first_name],
                    email: params[:email], 
                    telephone: params[:telephone], 
                    message: params[:message]).contact_mailer.deliver_now
    redirect_to contact_path 
    flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
  end

end
