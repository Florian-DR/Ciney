class AddMainPhotoToGites < ActiveRecord::Migration[7.0]
  def change
    add_column :gites, :main_photo_data, :text
  end
end
