class RepairReport < ActiveRecord::Base
  has_one :created_by, foreign_key: "created_by", class_name: "User"
  has_one :assigned, foreign_key: "assigned", class_name: "User"
end
