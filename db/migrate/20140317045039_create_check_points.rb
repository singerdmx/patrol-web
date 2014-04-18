class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.text :description
      t.string :name
      t.integer :category
      t.string :choice
      t.string :state
      t.string :barcode
      t.references :asset

      t.timestamps
    end
  end
end
