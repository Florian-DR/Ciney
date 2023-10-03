class AdminsController < ApplicationController

    def admin
        @saisons = Saison.all
        @saison = Saison.new
        @gite_1 = Gite.first
        @gite_2 = Gite.last
        @days_of_week = DaysOfWeek.new
    end
end
