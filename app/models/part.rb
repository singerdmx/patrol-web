# int "status": 0(正常), 1(保养), 2(报修), 3(其他)
class Part < ActiveRecord::Base
  belongs_to :asset
end
