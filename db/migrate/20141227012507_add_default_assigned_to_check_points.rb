class AddDefaultAssignedToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :default_assigned_id, :integer
  end
end
