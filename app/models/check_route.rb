class CheckRoute < ActiveRecord::Base
  has_many :route_builders
  has_many :assets , through: :route_builders

  has_many :check_sessions, dependent: :destroy
end
