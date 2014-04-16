class AddTypeBarcodeToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :type, :string
    add_column :check_points, :barcode, :string
  end
end
