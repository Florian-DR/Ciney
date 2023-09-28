class GitesController < ApplicationController
    before_action :current_gite, only: %i[edit add_pictures]

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

    def add_pictures
        raise
        @image = Cloudinary::Uploader.upload(params[:photos])
        @gite.photos.attach(io: @image, filename: params[:title], content_type: "image/png")
        raise
    end

    private

    def gite_params
        params.require(:gite).permit(:name, :description, :capacity, :rooms, :sanitary, :photo_principale, photos: [])
    end

    def current_gite
        @gite = Gite.find(params[:id])
    end

end
