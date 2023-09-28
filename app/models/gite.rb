class Gite < ApplicationRecord
    has_many :charges
    has_many :days_of_weeks

    has_one_attached :photo_principale
    has_many_attached :photos

    validates :name, :description, :capacity, :rooms, :sanitary, presence: true
    validates :capacity, :rooms, :sanitary, numericality: true
end
