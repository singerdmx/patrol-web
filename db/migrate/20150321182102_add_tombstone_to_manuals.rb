class AddTombstoneToManuals < ActiveRecord::Migration
  def change
    add_column :manuals, :tombstone, :boolean, :default => false
  end
end
