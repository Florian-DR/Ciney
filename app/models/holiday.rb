class Holiday < ApplicationRecord
    has_many :days

    validates :name, :start_date, :end_date, :price, presence: true
    validates :end_date, comparison: {other_than: :start_date, greater_than: :start_date}
    validates :price, numericality: true, numericality: {greater_than: 0}
    validates :start_date, uniqueness: {in: :start_date..:end_date}
end
