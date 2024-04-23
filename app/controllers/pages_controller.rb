class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @home = HomePage.first
    @gites = Gite.all.order(:id)
    photos = @home.entreprises_photos.each_with_index.select { |photo, index| index > 0 && index < 5 }
    @entreprises_photos = photos.map(&:first)
  end

  def admin
    @saisons = Saison.all
    @saison = Saison.new
    
    @gite_1 = Gite.first
    @gite_2 = Gite.last
    @gites = Gite.all.reverse
    
    
    @days_of_week = DaysOfWeek.new
    @gite_holidays = GiteHoliday.new
    
    @holidays = Holiday.all
    @holiday = Holiday.new
  end

end
