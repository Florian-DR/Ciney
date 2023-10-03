class Saison < ApplicationRecord
    has_many :days_of_weeks, dependent: :destroy

    validates :name, :start_date, :end_date, presence: true
    validates :end_date, comparison: {other_than: :start_date}

    def semaine_price(gite_id)
        days_of_weeks.find{|day| day.status == "semaine" && day.gite_id == gite_id}.price
    end

    def week_end_price(gite_id)
        days_of_weeks.find{|day| day.status == "week-end" && day.gite_id == gite_id}.price
    end

    def semaine_price?(gite_id)
        days_of_weeks.find{|day| day.status == "semaine" && day.gite_id == gite_id}
    end

    def week_end_price?(gite_id)
        days_of_weeks.find{|day| day.status == "week-end" && day.gite_id == gite_id}
    end

end
