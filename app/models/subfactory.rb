class Subfactory < ActiveRecord::Base
  belongs_to :factory

  has_many :areas
end
