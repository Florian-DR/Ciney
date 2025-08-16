class HomePagesController < ApplicationController
    def edit 
        @home = HomePage.first
    end

    def update
        @home = HomePage.find(params[:id])
        if @home.update(home_params.except(:photos))
            # add new uploaded images if present
            if params[:home_page][:photos].present?
                photos = params[:home_page][:photos].reject(&:blank?) #Remove default brower empty first element
                photos.each do |uploaded|
                    @home.photos.create(image: uploaded, photo_type: PhotoType::MAIN_PHOTOS )
                end
            end
            redirect_to root_path
            flash.notice = "Page d'acceuil modifié !"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def home_params
        params.require(:home_page)
            .permit(
                :introduction_title, 
                :introduction_text, 
                :gites_title, 
                :gites_description,
                :mariages_title, 
                :mariages_text, 
                :entreprises_title, 
                :decouvrir_title,
                photos: []
                )
    end
end
