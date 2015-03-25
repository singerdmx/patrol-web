class AddStatusToParts < ActiveRecord::Migration
  def change
    add_column :parts, :status, :integer, :default => 0
  end
end
