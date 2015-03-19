class ChangeResultIdNullableInRepairReports < ActiveRecord::Migration
  def change
    change_column_null(:repair_reports, :check_result_id, true )
  end
end
