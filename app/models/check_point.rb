class CheckPoint < ActiveRecord::Base

  belongs_to :asset

  has_many :check_results, dependent: :destroy
  has_many :route_builders
  has_many :check_routes, through: :route_builders

end
