class AddManualIdToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :manual_id, :integer
  end
end
