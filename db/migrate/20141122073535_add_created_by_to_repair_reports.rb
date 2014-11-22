class AddCreatedByToRepairReports < ActiveRecord::Migration
  def change
    add_column :repair_reports, :created_by, :integer
  end
end
