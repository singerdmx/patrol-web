class CreateRouteBuilders < ActiveRecord::Migration
  def change
    create_table :route_builders do |t|
      t.belongs_to :check_route
      t.belongs_to :asset
      t.timestamps
    end
  end
end
