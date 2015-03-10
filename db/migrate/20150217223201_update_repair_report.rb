class UpdateRepairReport < ActiveRecord::Migration
  def change
    change_column_null :repair_reports, :stopped, false
    change_column_null :repair_reports, :production_line_stopped, false
    change_column_null :repair_reports, :status, false
    change_column_null :repair_reports, :kind, false
    change_column_null :repair_reports, :check_result_id, false
    change_column_null :repair_reports, :area_id, false
    change_column_null :repair_reports, :asset_id, false
    change_column_null :repair_reports, :created_by_id, false
  end
end
