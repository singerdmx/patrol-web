class AddReportNumToRepairReports < ActiveRecord::Migration
  def change
    add_column :repair_reports, :report_num, :string, :null => false
    add_index :repair_reports, :report_num, :unique => true
  end
end
