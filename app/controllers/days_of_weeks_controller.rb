class DaysOfWeeksController < ApplicationController
    before_action :find_saison

    def create
        days_of_week = DaysOfWeek.new(days_of_week_params)
        
        days_of_week.saison = @saison
        if days_of_week.save
            redirect_to admin_path
            flash.notice = "Le prix a bien été créé"
        else
            @gites = Gite.all
            @saisons = Saison.all
            @saison = Saison.new
            @holidays = Holiday.all
            @holiday = Holiday.new
            @gite_holidays = GiteHoliday.new
            @charge = Charge.new


            @days_of_week = days_of_week

            render '/pages/admin', status: :unprocessable_entity
        end
    end

    def update
        @days_of_week = DaysOfWeek.find(params[:id])
        @days_of_week.saison = @saison  
        @days_of_week.update(days_of_week_params)

        respond_to do |format|
            format.html {redirect_to admin_path}
            format.text {render partial: "pages/admin", locals: {saison: @saison, gite: @gite_1, days_of_week: @days_of_week}}
        end
    end

    private

    def find_saison
        @saison = Saison.find(params[:saison_id])
    end

    def days_of_week_params
        params.require(:days_of_week).permit(:status, :price, :saison_id, :gite_id)
    end
end
