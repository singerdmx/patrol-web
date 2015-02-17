class UpdateRepairReport < ActiveRecord::Migration
  def change
    change_column_null :repair_reports, :stopped, false
    change_column_null :repair_reports, :production_line_stopped, false
    change_column_null :repair_reports, :status, false
  end
end
