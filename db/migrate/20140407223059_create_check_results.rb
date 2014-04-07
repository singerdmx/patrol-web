class CreateCheckResults < ActiveRecord::Migration
  def change
    create_table :check_results do |t|
      t.string :result
      t.integer :value
      t.datetime :check_time
      t.references :check_point
      t.references :check_session



      t.timestamps
    end
  end
end
