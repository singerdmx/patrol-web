class RouteBuilder < ActiveRecord::Base
  belongs_to :asset
  belongs_to :check_route
end
