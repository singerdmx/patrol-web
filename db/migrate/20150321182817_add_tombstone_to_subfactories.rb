class AddTombstoneToSubfactories < ActiveRecord::Migration
  def change
    add_column :subfactories, :tombstone, :boolean, :default => false
  end
end
