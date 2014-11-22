class AddCheckPointRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :check_point, index: true
  end
end
