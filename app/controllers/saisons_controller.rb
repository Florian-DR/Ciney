class SaisonsController < ApplicationController

    def create
        saison = Saison.new(saison_params)
        
        if saison.save
            redirect_to admin_path
        else
            @saisons = Saison.all
            @saison = Saison.new
            render '/admins/admin', inline: "<div class='text-danger'>Tous les champs obligatoires ne sont pas rempli ou bien les dates sont les mêmes</div>"
            
        end
    end

    def update
        raise
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
