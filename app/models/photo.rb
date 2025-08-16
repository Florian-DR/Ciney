class Photo < ApplicationRecord
  belongs_to :gite, optional: true
  belongs_to :home_page, optional: true
  include Shrine::Attachment(:image)

  def get_alt
    # For current instance
    JSON.parse(image_data)["metadata"]["filename"]
  end

  def self.get_alt(photo)
    # For instance in other's db/instances
    photo.metadata["filename"]
  end
end