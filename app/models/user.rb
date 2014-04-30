class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_builders
  has_many :check_routes, through: :user_builders
  has_many :user_preferences
  has_many :check_points, through: :user_preferences

  def preferred_points
    check_points
  end

  def all_points
    points = Set.new()
    check_routes.each { |route|
      points.merge(route.check_points)

    }
    points
  end

  def self.validate(point_id)
    if user_signed_in?
      current_user.all_points.map{|point| point.id}.include?(point_id.to_i)
    end
    true
  end

  private :check_points, :check_points=




end
