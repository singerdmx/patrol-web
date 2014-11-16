class AddManualIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :manual_id, :integer
  end
end
