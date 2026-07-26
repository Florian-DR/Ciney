class GitesController < ApplicationController
    skip_before_action :authenticate_user!, only: :show
    before_action :current_gite
    before_action :authorize_first_user!, except: :show

    def show
        if @gite.name.downcase.include?("ferme")
            render "fifth_gite"
        elsif @gite.name.downcase.include?("hirondelle")
            render "first_gite"
        elsif @gite.name.downcase.include?("grand")
            render "fourth_gite"
        elsif @gite.name.downcase.include?("horizon")
            render "second_gite"
        elsif @gite.name.downcase.include?("arbre")
            render "third_gite"
        end
    end

    def edit; end

    def update
        updated = Gite.transaction do
          if @gite.update(gite_params.except(:photos))
            Gite.where.not(id: @gite.id).update_all(
              commun: @gite.commun,
              updated_at: Time.current,
            )
            true
          else
            false
          end
        end

        if updated
                # add new uploaded images if present
            if params[:gite][:photos].present?
                photos = params[:gite][:photos].reject(&:blank?) #Remove default browser empty first element
                photos.each do |uploaded|
                    @gite.photos.create(image: uploaded, photo_type: PhotoType::GALLERY_GITE)
                end
            end
            
            redirect_to gite_path(@gite)
            flash.notice = "Gite modifié !"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def delete_pictures
        photo = @gite.photos.find(params[:photo_id])
        photo.destroy!

        flash.notice = "Une photo a bien été supprimée"
        redirect_back fallback_location: edit_gite_path(@gite)
    end

    private

    def gite_params
        params.require(:gite).permit(:name, :description, :capacity, :rooms, :sanitary, :commun, :main_photo ,:photo_principale, photos: [])
    end

    def current_gite
        # To have the gite from the params[:name] (url)
        @gite = Gite.all.find { |gite| gite.to_param == params[:name] }
        raise ActiveRecord::RecordNotFound unless @gite
    end

    def authorize_first_user!
        head :forbidden unless current_user == User.first
    end

end
