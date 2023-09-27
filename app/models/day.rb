class Day < ApplicationRecord
  belongs_to :daysOfWeek
  belongs_to :holiday
end
