class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.references :gite, foreign_key: true
      t.string     :type
      t.string     :from_page
      t.text       :image_data
      t.timestamps
    end
  end
end
