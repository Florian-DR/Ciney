class CreateGiteHolidays < ActiveRecord::Migration[7.0]
  def change
    create_table :gite_holidays do |t|
      t.references :holiday, null: false, foreign_key: true
      t.references :gite, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
