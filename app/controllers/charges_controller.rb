class ChargesController < ApplicationController
    before_action :charges_params
    def create
        @charge = Charge.new
        @charge.gite_id = Gite.where(name: params[:charge][:gite]).map(&:id).first
        @charge.name = params[:charge][:name]
        @charge.kind = params[:charge][:kind]
        @charge.price = params[:charge][:price]
        if @charge.save 
            redirect_to admin_path
        else 
            @saisons = Saison.all
            @saison = Saison.new
            @gites = Gite.all
            @holidays = Holiday.all
            
            @days_of_week = DaysOfWeek.new
            @gite_holidays = GiteHoliday.new
            @holiday = Holiday.new

            render "/pages/admin", status: :unprocessable_entity
        end
    end

    private 
    def charges_params
        params.require(:charge).permit(:gite, :name, :kind, :price)
    end
end
