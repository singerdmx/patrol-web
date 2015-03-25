class ChangeReportTypeNotNullableInRepairReports < ActiveRecord::Migration
  def change
    change_column_null(:repair_reports, :report_type, false )
  end
end
