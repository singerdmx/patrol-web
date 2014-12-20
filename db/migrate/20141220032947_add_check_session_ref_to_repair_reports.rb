class AddCheckSessionRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :check_session, index: true
  end
end
