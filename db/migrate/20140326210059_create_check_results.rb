class CreateCheckResults < ActiveRecord::Migration
  def change
    create_table :check_results do |t|
      t.string :result
      t.integer :session
      t.references :check_point
      t.references :check_route



      t.timestamps
    end
  end
end
