class CheckRoute < ActiveRecord::Base
  has_many :route_builders
  has_many :check_points , through: :route_builders

  has_many :check_sessions, dependent: :destroy
end
