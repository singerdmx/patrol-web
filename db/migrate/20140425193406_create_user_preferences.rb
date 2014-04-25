class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.belongs_to :user
      t.belongs_to :check_point
      t.timestamps
    end
  end
end

