class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.text :description
      t.integer :name
      t.string :type
      t.string :choice
      t.string :status
      t.string :barcode
      t.references :asset

      t.timestamps
    end
  end
end
