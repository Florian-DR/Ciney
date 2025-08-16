class AddHomePagesReferencesToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_reference :photos, :home_page, foreign_key: true
  end
end
