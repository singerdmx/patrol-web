class CheckRoute < ActiveRecord::Base
  has_and_belongs_to_many :assets
end
