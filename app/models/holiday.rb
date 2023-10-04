class Holiday < ApplicationRecord
    has_many :days
    has_many :gite_holidays, dependent: :destroy


    validates :name, :start_date, :end_date, presence: true
    validates :end_date, comparison: {other_than: :start_date, greater_than: :start_date}
    # validates :price, numericality: true, numericality: {greater_than: 0}
    validates :start_date, uniqueness: {in: :start_date..:end_date}

    def price(gite_id)
        gite_holidays.find{|day| day.gite_id == gite_id}.price
    end

    def price?(gite_id)
        gite_holidays.find{|day| day.gite_id == gite_id}
    end
end
