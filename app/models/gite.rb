class Gite < ApplicationRecord
    has_many :charges
    has_many :days_of_weeks
    has_many :gite_holidays
    has_many :holidays, through: :gite_holidays
    has_many :saisons, through: :days_of_weeks
    has_many :photos, inverse_of: :gite, dependent: :destroy
    accepts_nested_attributes_for :photos

    include Shrine::Attachment(:main_photo)

    validates :name, :description, :capacity, :rooms, :sanitary, presence: true
    validates :capacity, :rooms, :sanitary, numericality: true
    validates :name, uniqueness: true

    # require "googleauth"


    def to_param
      # To have the name without space in the url
      name.downcase.delete(" \'")
    end

    def name_with_capacity
      "#{name} (#{capacity} pers.)"
    end

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
    # def price(day)
    #     holidays.each do |holiday|
    #         return gite_holidays.where(holiday: holiday).first.price if ((holiday.start_date..holiday.end_date).to_a.include? day)
    #     end
        
    #     saisons.each do |saison|
    #         if ((saison.start_date..saison.end_date).to_a.include? day) 
    #             status = (day.saturday? || day.friday? || day.sunday?) ? "week-end" : "semaine"
    #             day_price = days_of_weeks.where(saison: saison, status: status)
                
    #             return (day_price.first.price) unless day_price.empty? 
    #         end

    #     end

    #     "undefined"
    # end

    # def events_dates
    #   non_available = []
    #   events.each do |event|
    #     if event.start.date_time
    #       (event.start.date_time.to_date...event.end.date_time.to_date).to_a.each { |event_date| non_available << event_date }
    #     else 
    #       (event.start.date..event.end.date).to_a.each { |event_date| non_available << event_date }
    #     end
    #   end
    #   non_available
    # end

    # private

    # def events
    #   calendar = Google::Apis::CalendarV3::CalendarService.new
    #   calendar.authorization = Google::Apis::RequestOptions.default.authorization
    #   # Replace with your actual calendar ID
      
    #   if name.downcase.include?("hirondelle")
    #     calendar_id = ENV['CALENDAR_HIRONDELLES']
    #   elsif name.downcase.include?("horizon")
    #     calendar_id = ENV['CALENDAR_HORIZON']
    #   elsif name.downcase.include?("arbre")
    #     calendar_id = ENV['CALENDAR_ARBRE_DE_VIE']
    #   end
     
    #   events = calendar.list_events(calendar_id,
    #                                 max_results: 30,
    #                                 single_events: true,
    #                                 order_by: 'startTime',
    #                                 time_min: Time.now.iso8601)

    #   events = events.items
    # end
      
end
