class ChargesController < ApplicationController
    before_action :charges_params, except: :destroy
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
            @gites = Gite.all.order(:id)
            @holidays = Holiday.all
            @charges = Charge.all
            
            @days_of_week = DaysOfWeek.new
            @gite_holidays = GiteHoliday.new
            @holiday = Holiday.new

            render "/pages/admin", status: :unprocessable_entity
        end
    end

    def update
        @charge = Charge.find(params[:id])  
        @charge.update(charges_params)

        respond_to do |format|
            format.html {redirect_to admin_path}
            format.text {render partial: "pages/admin", locals: { gite: @gite, charge: @charge}}
        end
    end

    def destroy
        charge = Charge.find(params[:id])
        redirect_to admin_path if charge.destroy
    end

    private 
    def charges_params
        params.require(:charge).permit(:gite, :name, :kind, :price)
    end
end
