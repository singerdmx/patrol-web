class Asset < ActiveRecord::Base
  has_many :check_points, dependent: :destroy
  has_many :parts, dependent: :destroy
end
