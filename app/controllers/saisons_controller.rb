class SaisonsController < ApplicationController

    def create
        saison = Saison.new(saison_params)
        if saison.save
            redirect_to admin_path
        else
            @gite_1 = Gite.first
            @gite_2 = Gite.last
            @days_of_week = DaysOfWeek.new
            @saisons = Saison.all
            @saison = saison

            render '/admins/admin', status: :unprocessable_entity
            
        end
    end

    def update
        saison = Saison.new(saison_params)
        if saison.save
            redirect_to admin_path
        else
            @saisons = Saison.all
            @saison = Saison.new
            render '/admins/admin', status: :unprocessable_entity
        end

    end

    private

    def saison_params
        params.require(:saison).permit(:name, :start_date, :end_date)
    end
end
