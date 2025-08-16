class Photo < ApplicationRecord
  belongs_to :gite
  include Shrine::Attachment(:image)
end