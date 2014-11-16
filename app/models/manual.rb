class Manual < ActiveRecord::Base

  has_many :assets
  has_many :check_points
end
