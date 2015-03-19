class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :name
      t.string :description
      t.string :barcode
      t.references :asset, index: true
      t.integer :default_assigned_id

      t.timestamps
    end
  end
end
