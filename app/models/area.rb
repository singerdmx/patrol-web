class Area < ActiveRecord::Base
  belongs_to :subfactory

  has_many :check_routes
end
