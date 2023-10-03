class DaysOfWeek < ApplicationRecord
  belongs_to :gite
  belongs_to :saison

  has_many :days

  validates :status, :saison_id, :price, :gite_id, presence: true
  validates :price, numericality: true, numericality: {greater_than: 0}
  validates :status, uniqueness: {scope: [:saison_id, :gite_id]}

end
