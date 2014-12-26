class AddNewColumnToCheckPoint < ActiveRecord::Migration
  def change
    add_column :check_points, :measure_unit, :string
    add_column :check_points, :point_code, :string
  end
end
