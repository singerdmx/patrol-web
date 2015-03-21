class AddTombstoneToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :tombstone, :boolean, :default => false
  end
end
