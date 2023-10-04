class HolidaysController < ApplicationController

    def create
        @holiday = Holiday.new(holidays_params)
        if @holiday.save
            redirect_to admin_path
        else
            @saisons = Saison.all
            @saison = Saison.new
            @gite_1 = Gite.first
            @gite_2 = Gite.last
            @days_of_week = DaysOfWeek.new

            @holidays = Holiday.all

            render "/admins/admin", status: :unprocessable_entity
        end

    end

    private

    def holidays_params
        params.require(:holiday).permit(:name, :start_date, :end_date, :price)
    end
end
