class AddMainPhotoToGites < ActiveRecord::Migration[7.0]
  def change
    add_column :gites, :image_data, :text
  end
end
