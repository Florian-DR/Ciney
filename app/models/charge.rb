class Charge < ApplicationRecord
  belongs_to :gite
  $kinds = ["Personne", "Reservation"]
  validates :kind, inclusion: {:in => $kinds}
  validates :kind, :name, :price, presence: true
  validates :price, numericality: true, numericality:{ greater_than: 0} 
end
