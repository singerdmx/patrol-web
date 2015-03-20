class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_builders
  has_many :check_routes, through: :user_builders
  has_many :user_preferences
  has_many :check_points, through: :user_preferences

  has_many :repair_reports

  def preferred_points
    check_points
  end

  def all_points
    points = Set.new()
    if is_user?
      routes = check_routes
    else
      #TODO what about leader?
      routes = CheckRoute.all
    end

    routes.each { |route|
      points.merge(route.check_points)

    }

    points
  end

  def patrol_user?
    read_attribute(:role).in? [0,1,2,7,8]
  end

  def repair_user?
    read_attribute(:role).in? [3,4,5,6,7,8]
  end

  def is_admin?
    read_attribute(:role).in? [0,3,7]
  end

  def is_leader?
    read_attribute(:role).in? [1,4,8]
  end

  def is_user?
    read_attribute(:role).in? [2,5]
  end

  def is_worker?
    read_attribute(:role) == 6
  end

  def self.validate(point_id)
    if user_signed_in?
      current_user.all_points.map{|point| point.id}.include?(point_id.to_i)
    end
    true
  end

  private :check_points, :check_points=

end
