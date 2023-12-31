class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
      t.date :date
      t.references :days_of_week, null: false, foreign_key: true
      t.references :holiday, foreign_key: true

      t.timestamps
    end
  end
end
