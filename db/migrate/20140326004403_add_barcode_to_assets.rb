class AddBarcodeToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :barcode, :string
    add_index :assets, :barcode
  end
end
