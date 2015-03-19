class RemoveManualFromCheckPoints < ActiveRecord::Migration
  def change
    remove_column :check_points, :manual_id, :reference
  end
end
