class AddAssignedToRepairReports < ActiveRecord::Migration
  def change
    add_column :repair_reports, :assigned, :integer
  end
end
