class CheckRoute < ActiveRecord::Base
  has_and_belongs_to_many :assets
  has_many :check_results, dependent: :destroy
end
