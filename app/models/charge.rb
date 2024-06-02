class Charge < ApplicationRecord
  belongs_to :gite
  TYPES = ["person", "reservation"]
  validates :type, inclusion: {:in => TYPES}
end
