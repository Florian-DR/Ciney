class GitesController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[show first_gite second_gite third_gite]
    before_action :current_gite

    def show
        if params["start_date"] && session[:dates]
            @non_available = session[:dates]
        else
            @non_available = session[:dates] = @gite.events_dates
        end
    
        if @gite.name.downcase.include?("hirondelle")
            render "first_gite"
        elsif @gite.name.downcase.include?("horizon")
            render "second_gite"
        elsif @gite.name.downcase.include?("arbre")
            render "third_gite"
        end
    end

    def edit; end

    def update
        Gite.all.each do |gite| 
          gite.commun = params[:gite][:commun]
          gite.save
        end
        if @gite.update(gite_params)
            redirect_to gite_path
            flash.notice = "Gite modifié !"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def delete_pictures
        photo = @gite.photos[params[:photo_index].to_i]
        photo.purge
        flash.notice = "Une photo a bien été supprimée"
        redirect_to request.referer
    end

    private

    def gite_params
        params.require(:gite).permit(:name, :description, :capacity, :rooms, :sanitary, :commun, :photo_principale, photos: [])
    end

    def current_gite
        # To have the gite from the params[:name] (url)
        @gite = Gite.all.select{ |gite| gite.name.downcase.delete(" \'") == params[:name] }.first
    end

end
