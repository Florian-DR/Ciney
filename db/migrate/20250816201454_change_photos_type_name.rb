class ChangePhotosTypeName < ActiveRecord::Migration[7.0]
  def change
    rename_column :photos, :type, :photo_type 
  end
end
