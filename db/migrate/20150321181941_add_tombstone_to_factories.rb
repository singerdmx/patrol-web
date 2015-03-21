class AddTombstoneToFactories < ActiveRecord::Migration
  def change
    add_column :factories, :tombstone, :boolean, :default => false
  end
end
