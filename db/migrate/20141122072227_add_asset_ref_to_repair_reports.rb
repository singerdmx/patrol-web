class AddAssetRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :asset, index: true
  end
end
