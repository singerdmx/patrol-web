class AddCheckSessionRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :check_result, index: true
  end
end
