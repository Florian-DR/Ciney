class CreateDaysOfWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :days_of_weeks do |t|
      t.string :status
      t.float :price
      t.references :gite, null: false, foreign_key: true
      t.references :saison, null: false, foreign_key: true

      t.timestamps
    end
  end
end
