class AddPartRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    add_column :users, :name, :string
  end
end
