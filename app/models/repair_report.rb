require 'csv'

# string "report_type": 1 (保养), 2(报修), 3(其他)
class RepairReport < ActiveRecord::Base
  include ModelHelper

  belongs_to :created_by_user, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :assigned_to_user, :class_name => "User", :foreign_key => "assigned_to_id"

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |row|
        r = ModelHelper::to_hash(row)
        csv << r.values
      end
    end
  end
end
