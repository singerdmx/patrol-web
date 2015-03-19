class AddPartRefToRepairReports < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :part, index: true
  end
end
