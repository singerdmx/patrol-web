class RepairReport < ActiveRecord::Base
  belongs_to :created_by_user, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :assigned_to_user, :class_name => "User", :foreign_key => "assigned_to_id"
end
