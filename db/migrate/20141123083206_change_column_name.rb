class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :repair_reports, :created_by, :created_by_id
    rename_column :repair_reports, :assigned, :assigned_to_id
  end
end
