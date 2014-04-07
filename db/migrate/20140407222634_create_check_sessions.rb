class CreateCheckSessions < ActiveRecord::Migration
  def change
    create_table :check_sessions do |t|
      t.string :user
      t.string :session
      t.datetime :start_time
      t.datetime :end_time
      t.references :check_route, index: true

      t.timestamps
    end
  end
end
