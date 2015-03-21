class AddTombstoneToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :tombstone, :boolean, :default => false
  end
end
