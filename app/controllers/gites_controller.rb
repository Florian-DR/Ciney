class GitesController < ApplicationController
    before_action :current_gite, only: %i[edit delete_pictures]

    def index
        @gites = Gite.all.order(:id)
    end

    def edit; end

    def update
        @gite = Gite.find(params[:id])
        if @gite.update(gite_params)
            redirect_to gites_path
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
        params.require(:gite).permit(:name, :description, :capacity, :rooms, :sanitary, :photo_principale, photos: [])
    end

    def current_gite
        @gite = Gite.find(params[:id])
    end

end
