class AddDefaultValueToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :default_value, :string
  end
end
