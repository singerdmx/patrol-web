class ChangeStringFormatInRepairReports < ActiveRecord::Migration
  def up
    change_column :repair_reports, :description, :text
    change_column :repair_reports, :content, :text
  end

  def down
    change_column :repair_reports, :description, :string
    change_column :repair_reports, :content, :string
  end
end
