class CreateCheckResults < ActiveRecord::Migration
  def change
    create_table :check_results do |t|
      t.string :result
      t.integer :status
      t.string :memo
      t.datetime :check_time
      t.references :check_point
      t.references :check_session



      t.timestamps
    end
  end
end
