class AddResultImageRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :result_image, index: true
  end
end
