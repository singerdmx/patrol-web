class AddManualToCheckPoints < ActiveRecord::Migration
  def change
    add_reference :check_points, :manual, index: true
  end
end
