class UserBuilder < ActiveRecord::Base
  belongs_to :check_route
  belongs_to :user
end
