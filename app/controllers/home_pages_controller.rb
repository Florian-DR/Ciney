class HomePagesController < ApplicationController
    def edit 
        @home = HomePage.first
    end

    def update
        home = HomePage.find(params[:id])
        if home.update(home_params)
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
                main_photos: [],
                entreprises_photos: [])
    end
end
