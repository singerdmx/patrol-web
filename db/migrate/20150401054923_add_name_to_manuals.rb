class AddNameToManuals < ActiveRecord::Migration
  def change
    add_column :manuals, :name, :string, :null => false
  end
end
