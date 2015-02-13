require 'csv'

class RepairReport < ActiveRecord::Base
  belongs_to :created_by_user, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :assigned_to_user, :class_name => "User", :foreign_key => "assigned_to_id"

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |row|
        csv << row.attributes.values_at(*column_names)
      end
    end
  end
end
