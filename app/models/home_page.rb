class HomePage < ApplicationRecord
    has_many :photos, inverse_of: :home_page, dependent: :destroy
    accepts_nested_attributes_for :photos
end
