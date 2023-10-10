class Gite < ApplicationRecord
    has_many :charges
    has_many :days_of_weeks
    has_many :gite_holidays
    has_many :holidays, through: :gite_holidays
    has_many :saisons, through: :days_of_weeks

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

    # Retrieve the price of each day through holidays and saisons for the /gites pages on the calendar
    def price(day)
        holidays.each do |holiday|
            return gite_holidays.where(holiday: holiday).first.price if ((holiday.start_date..holiday.end_date).to_a.include? day)
        end
        
        saisons.each do |saison|
            if ((saison.start_date..saison.end_date).to_a.include? day) 
                status = (day.saturday? || day.friday? || day.sunday?) ? "week-end" : "semaine"
                return (days_of_weeks.where(saison: saison, status: status).first.price)
            end

            # if ((saison.start_date..saison.end_date).to_a.include? day)
            #     saison.week_end_price?
            # end
        end

        "undefined"
    end
end
