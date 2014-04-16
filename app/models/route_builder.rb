class RouteBuilder < ActiveRecord::Base
  belongs_to :check_point
  belongs_to :check_route
end
