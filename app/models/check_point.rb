class CheckPoint < ActiveRecord::Base

  belongs_to :asset

  belongs_to :user, :foreign_key => "default_assigned_id"

  has_many :check_results, dependent: :destroy
  has_many :route_builders
  has_many :check_routes, through: :route_builders

end
