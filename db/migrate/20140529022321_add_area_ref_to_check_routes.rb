class AddAreaRefToCheckRoutes < ActiveRecord::Migration
  def change
    add_reference :check_routes, :area, index: true
  end
end
