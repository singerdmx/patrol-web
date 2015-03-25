class ChangeAreaIdNullableInRepairReports < ActiveRecord::Migration
  def change
    change_column_null(:repair_reports, :area_id, true )
  end
end
