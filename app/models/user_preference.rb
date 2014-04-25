class UserPreference < ActiveRecord::Base
  belongs_to :check_point
  belongs_to :user
end
