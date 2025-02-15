class GitesController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    before_action :current_gite, only: %i[show edit delete_pictures]
    before_action :all_gites, only: %i[show edit index]

    def index
        @events = Gite.events
        @non_available = Gite.events_dates
    end

    def show
      @events = Gite.events
      @non_available = Gite.events_dates
    end

    # def new
        #     @gite = Gite.new
    # end

    # def create
        #     @gite = Gite.new(gite_params)
        #     @gite.commun = Gite.first.commun
        #     if @gite.save
            #         redirect_to gites_path
        #     else
            #         render :new, status: :unprocessable_entity
        #     end
    # end

    def edit; end

    def update
        @gite = Gite.find(params[:id])
        Gite.all.each do |gite| 
          gite.commun = params[:gite][:commun]
          gite.save
        end
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
        params.require(:gite).permit(:name, :description, :capacity, :rooms, :sanitary, :commun, :photo_principale, photos: [])
    end

    def current_gite
        # To have the name without space in the url
        @gite = Gite.all.select{ |gite| gite.name.downcase.delete(" \'") == params[:name] }.first
    end

end
