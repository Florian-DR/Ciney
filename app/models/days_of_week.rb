class DaysOfWeek < ApplicationRecord
  belongs_to :gite
  belongs_to :saison

  has_many :days
end
