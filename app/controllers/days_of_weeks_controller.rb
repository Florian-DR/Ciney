class DaysOfWeeksController < ApplicationController
    def create
        days_of_week = DaysOfWeek.new(days_of_week_params)
        days_of_week.saison = Saison.find(params[:saison_id])
        if days_of_week.save
            redirect_to admin_path
            flash.notice = "Le prix a bien été créé"
        else
            @gite_1 = Gite.first
            @gite_2 = Gite.last
            @saisons = Saison.all
            @days_of_week = days_of_week
            @saison = Saison.new

            render '/admins/admin', status: :unprocessable_entity
        end
    end

    private

    def days_of_week_params
        params.require(:days_of_week).permit(:status, :price, :saison_id, :gite_id)
    end
end
