class Gite < ApplicationRecord
    has_many :charges
    has_many :days_of_weeks
    has_many :gite_holidays

    has_one_attached :photo_principale
    has_many_attached :photos

    validates :name, :description, :capacity, :rooms, :sanitary, presence: true
    validates :capacity, :rooms, :sanitary, numericality: true


    ### Todo ###
    # 1. Add a column selected photos to gite
    # 2. Be able to add/remove some of them
    # 3. Retrieve them from anywhere or just from the gites#controller

    # def select_photo
    #     @photos << @gite.photo[params[:photo_index].to_i]
    # end

    # def deselect_photo
    #     @photos.delete(@gite.photo[params[:photo_index].to_i])
    # end

    # def selected_photos
    #     ## An array of index
    #     indexes = @gite.selected_photo 
    #     arr = []
    #     ## Retrieve the selected photos with the indexes
    #     indexes.each { |index| arr << @gite.photos.where(id: index)}
    # end
end
