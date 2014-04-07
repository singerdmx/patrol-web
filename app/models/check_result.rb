class CheckResult < ActiveRecord::Base
  belongs_to :check_session
  belongs_to :check_point

end
