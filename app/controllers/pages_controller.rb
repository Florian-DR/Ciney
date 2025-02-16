class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact]
  def home
    @home = HomePage.first
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

end
