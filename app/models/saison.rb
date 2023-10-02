class Saison < ApplicationRecord
    has_many :days_of_weeks

    validates :name, :start_date, :end_date, presence: true
    validates :start_date, uniqueness: {scope: :end_date, message: "Le début et la fin de saison doivent avoir une date différente"}
end
