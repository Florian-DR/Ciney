class Gite < ApplicationRecord
    has_many :charges
    has_many :days_of_weeks
end
