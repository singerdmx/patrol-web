class CreateUserBuilders < ActiveRecord::Migration
  def change
    create_table :user_builders do |t|
      t.integer :user_id
      t.integer :check_route_id

      t.timestamps
    end
  end
end
