class Asset < ActiveRecord::Base
  has_many :route_builders
  has_many :check_routes, through: :route_builders
  has_many :check_points, dependent: :destroy
end
