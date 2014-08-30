# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'securerandom'
require 'json'

Factory.delete_all
Subfactory.delete_all
Area.delete_all

factory = Factory.create({name: "市北物业"})

subfactory1 = factory.subfactories.create( name: "服务业园区" )

area1 = subfactory1.areas.create( name: "第n楼" )


CheckRoute.delete_all
Asset.delete_all
CheckPoint.delete_all
CheckResult.delete_all
User.delete_all

user1 = User.create! do |u|
  u.email = 'user@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 2
  u.name = "u1"
  #u.ensure_authentication_token!
end

user4 = User.create! do |u|
  u.email = 'admin@test.com'
  u.password = 'admin1234'
  u.password_confirmation = 'admin1234'
  u.role = 0
  u.name = 'admin'
  #u.ensure_authentication_token!
end

asset1 = Asset.create({
                barcode: "GXWY1408291010001",
                name: "甲进线",
                description: "甲进线 GXWY1408291010001" })
asset1.check_points.create([
                {
                   name:         "电压（KV）ab",
                   description:  "测量",
                   category:     20,
                   choice:       '[]',
                   frequency:    24
                },
                {
                   name:         "电压（KV）bc",
                   description:  "测量",
                   category:     20,
                   choice:       '[]',
                   frequency:    24
                },
                {
                  name:         "电压（KV）ca",
                  description:  "测量",
                  category:     20,
                  choice:       '[]',
                  frequency:    24
                } ])

asset2 = Asset.create({
                barcode: "GXWY1408291010002",
                name: "甲进线",
                description: "甲进线 GXWY1408291010002" })
asset2.check_points.create([
                {
                   name:         "电流（A）a",
                   description:  "测量",
                   category:     20,
                   choice:       '[]',
                   frequency:    24
                },
                {
                   name:         "电流（A）b",
                   description:  "测量",
                   category:     20,
                   choice:       '[]',
                   frequency:    24
                },
                {
                   name:         "电流（A）c",
                   description:  "测量",
                   category:     20,
                   choice:       '[]',
                   frequency:    24
                } ])


route1 = area1.check_routes.create!(
    {name: "高配电设备巡检（二路进线配电房）", description: "高配电设备巡检（二路进线配电房）"})
route1.check_points << asset1.check_points
route1.check_points << asset2.check_points


#adding preference points
user1.preferred_points <<  asset1.check_points
user1.preferred_points <<  asset2.check_points

#adding user to route
route1.users << user1
