class AddContactsToCheckRoutes < ActiveRecord::Migration
  def change
    add_column :check_routes, :contacts, :string
  end
end
