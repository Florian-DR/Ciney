class AddCommunToGite < ActiveRecord::Migration[7.0]
  def change
    add_column :gites, :commun, :text
  end
end
