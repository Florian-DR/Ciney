class GitesController < ApplicationController
    before_action :current_gite, only: %i[edit delete_pictures]
    before_action :events, only: :index

    require "googleauth"



    def index
        @gites = Gite.all.order(:id)
    end

    # def new
    #     @gite = Gite.new
    # end

    # def create
    #     @gite = Gite.new(gite_params)
    #     if @gite.save
    #         redirect_to gites_path
    #     else
    #         render :new, status: :unprocessable_entity
    #     end
    # end

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

    def events

        calendar = Google::Apis::CalendarV3::CalendarService.new
        calendar.authorization = Google::Apis::RequestOptions.default.authorization
    
        # Replace with your actual calendar ID
        calendar_id = 'florian.radigues@gmail.com'
    
        events = calendar.list_events(calendar_id,
                                      max_results: 15,
                                      single_events: true,
                                      order_by: 'startTime',
                                      time_min: Time.now.iso8601)
    
        @events = events.items
      end
end
