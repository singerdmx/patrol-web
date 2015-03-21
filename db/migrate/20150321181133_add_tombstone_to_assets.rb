class AddTombstoneToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :tombstone, :boolean, :default => false
  end
end
