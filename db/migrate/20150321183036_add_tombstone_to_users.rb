class AddTombstoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tombstone, :boolean, :default => false
  end
end
