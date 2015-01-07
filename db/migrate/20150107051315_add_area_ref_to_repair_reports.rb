class AddAreaRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :area, index: true
  end
end
