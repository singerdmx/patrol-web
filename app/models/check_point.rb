class CheckPoint < ActiveRecord::Base

  belongs_to :asset

  has_many :check_results, dependent: :destroy

end
