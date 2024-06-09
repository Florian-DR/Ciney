class GiteHolidaysController < ApplicationController

    def create
        @gite_holiday = GiteHoliday.new(holidays_params)
        @gite_holiday.holiday = Holiday.find(params[:holiday_id])
        if @gite_holiday.save
            redirect_to admin_path
        else
            @saisons = Saison.all
            @saison = Saison.new
            
            @gites = Gite.all.reverse
            
            @days_of_week = DaysOfWeek.new
            @charge = Charge.new

            @holidays = Holiday.all
            @holiday = Holiday.new

            render "pages/admin", status: :unprocessable_entity
        end
    end

    def update
        @gite_holiday = GiteHoliday.find(params[:id])
        @gite_holiday.holiday = Holiday.find(params[:holiday_id])  
        @gite_holiday.update(holidays_params)
        respond_to do |format|
            format.html {redirect_to admin_path}
            format.text {render partial: "pages/admin", locals: {holiday: @holiday, gite: @gite, gite_holiday: @gite_holiday}}
        end
    end

    private

    def holidays_params
        params.require(:gite_holiday).permit(:price, :gite_id, :holiday_id)
    end

end
