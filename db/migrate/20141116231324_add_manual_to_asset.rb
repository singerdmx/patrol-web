class AddManualToAsset < ActiveRecord::Migration
  def change
    add_reference :assets, :manual, index: true
  end
end
