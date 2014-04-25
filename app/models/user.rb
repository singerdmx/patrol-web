class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_builders
  has_many :check_routes, through: :user_builders
  has_many :user_preferences
  has_many :check_points, through: :user_preferences
end
