class ChangeStringFormatInRepairReports < ActiveRecord::Migration
  def up
    change_column :repair_reports, :description, :text
    change_column :repair_reports, :content, :text
    change_column :repair_reports, :report_type, 'integer USING CAST(report_type AS integer)'
  end

  def down
    change_column :repair_reports, :description, :string
    change_column :repair_reports, :content, :string
    change_column :repair_reports, :report_type, :string
  end
end
