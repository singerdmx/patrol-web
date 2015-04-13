class AddStandardToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :standard, :string
  end
end
