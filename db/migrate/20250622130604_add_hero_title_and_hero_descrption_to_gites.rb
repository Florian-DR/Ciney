class AddHeroTitleAndHeroDescrptionToGites < ActiveRecord::Migration[7.0]
  def change
    add_column :gites, :hero_title, :string
    add_column :gites, :hero_description, :text
  end
end
