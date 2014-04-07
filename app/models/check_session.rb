class CheckSession < ActiveRecord::Base
  belongs_to :check_route
  has_many :check_results, dependent: :destroy
end
