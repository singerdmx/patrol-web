class AddTombstoneToParts < ActiveRecord::Migration
  def change
    add_column :parts, :tombstone, :boolean, :default => false
  end
end
