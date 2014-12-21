require 'json'

Factory.delete_all
Subfactory.delete_all
Area.delete_all

factory = Factory.create({name: "总工厂"})

subfactory1 = factory.subfactories.create( name: "分工厂 一" )

area1 = subfactory1.areas.create( name: "一工区" )

CheckRoute.delete_all
Asset.delete_all
CheckPoint.delete_all
CheckResult.delete_all
User.delete_all

user1 = User.create! do |u|
  u.email = 'user1@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 2
  u.name = "巡检员1"
end

user2 = User.create! do |u|
  u.email = 'user2@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 2
  u.name = "维修工2"
end

user3 = User.create! do |u|
  u.email = 'user3@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 1
  u.name = '经理'
  #u.ensure_authentication_token!
end

user4 = User.create! do |u|
  u.email = 'admin@test.com'
  u.password = 'admin1234'
  u.password_confirmation = 'admin1234'
  u.role = 0
  u.name = '管理员'
  #u.ensure_authentication_token!
end

user5 = User.create! do |u|
  u.email = 'worker@test.com'
  u.password = 'worker1234'
  u.password_confirmation = 'worker1234'
  u.role = 6
  u.name = '维修工1'
  #u.ensure_authentication_token!
end

user6 = User.create! do |u|
  u.email = 'worker3@test.com'
  u.password = 'worker1234'
  u.password_confirmation = 'worker1234'
  u.role = 6
  u.name = '维修工3'
  #u.ensure_authentication_token!
end
