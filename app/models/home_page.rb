class HomePage < ApplicationRecord
    has_many_attached :main_photos
    has_many_attached :entreprises_photos
    has_many_attached :découvrir_photos
end
