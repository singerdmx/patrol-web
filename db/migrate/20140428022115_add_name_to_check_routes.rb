class AddNameToCheckRoutes < ActiveRecord::Migration
  def change
    add_column :check_routes, :name, :string
  end
end
