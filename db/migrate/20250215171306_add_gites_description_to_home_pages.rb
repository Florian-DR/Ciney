class AddGitesDescriptionToHomePages < ActiveRecord::Migration[7.0]
  def change
    add_column :home_pages, :gites_description, :text
  end
end
