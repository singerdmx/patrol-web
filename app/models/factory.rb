class Factory < ActiveRecord::Base
  has_many :subfactories, dependent: :destroy
end
