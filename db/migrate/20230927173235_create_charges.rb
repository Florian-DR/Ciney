class CreateCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :charges do |t|
      t.string :name
      t.float :price
      t.string :kind
      t.references :gite, null: false, foreign_key: true

      t.timestamps
    end
  end
end
