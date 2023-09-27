class CreateGites < ActiveRecord::Migration[7.0]
  def change
    create_table :gites do |t|
      t.string :name
      t.text :description
      t.integer :capacity
      t.integer :rooms
      t.integer :sanitary

      t.timestamps
    end
  end
end
