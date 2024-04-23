class SaisonsController < ApplicationController

    def create
        saison = Saison.new(saison_params)
        if saison.save
            redirect_to admin_path
        else
            @gites = Gite.all.reverse
            
            @days_of_week = DaysOfWeek.new
            @gite_holidays = GiteHoliday.new

            @holidays = Holiday.all
            @holiday = Holiday.new

            @saisons = Saison.all
            @saison = saison

            render '/pages/admin', status: :unprocessable_entity
        end
    end

    def destroy
        saison = Saison.find(params[:id])
        redirect_to admin_path if saison.destroy
    end

    private

    def saison_params
        params.require(:saison).permit(:name, :start_date, :end_date)
    end
end
