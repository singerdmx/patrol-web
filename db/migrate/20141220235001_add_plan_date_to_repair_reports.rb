class AddPlanDateToRepairReports < ActiveRecord::Migration
  def change
    add_column :repair_reports, :plan_date, :date
  end
end
