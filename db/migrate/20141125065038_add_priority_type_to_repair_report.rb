class AddPriorityTypeToRepairReport < ActiveRecord::Migration
  def change
    add_column :repair_reports, :priority, :integer
    add_column :repair_reports, :report_type, :string
    add_column :repair_reports, :status, :integer
  end
end
