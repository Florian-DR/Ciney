class AdminsController < ApplicationController

    def admin
        @saisons = Saison.all
        @saison = Saison.new
        @gite_1 = Gite.first
        @gite_2 = Gite.last
    end
end
