class GiteHoliday < ApplicationRecord
  belongs_to :holiday
  belongs_to :gite

  validates :price, :gite_id, :holiday_id, presence: true
  validates :price, numericality:{ greater_than: 0}
  validates :gite, uniqueness: {scope: :holiday}
end
