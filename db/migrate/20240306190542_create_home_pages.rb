class CreateHomePages < ActiveRecord::Migration[7.0]
  def change
    create_table :home_pages do |t|
      t.string :introduction_title
      t.text :introduction_text
      t.string :gites_title
      t.string :mariages_title
      t.text :mariages_text
      t.string :entreprises_title
      t.string :decouvrir_title

      t.timestamps
    end
  end
end
