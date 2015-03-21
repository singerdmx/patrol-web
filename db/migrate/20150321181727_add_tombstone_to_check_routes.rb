class AddTombstoneToCheckRoutes < ActiveRecord::Migration
  def change
    add_column :check_routes, :tombstone, :boolean, :default => false
  end
end
