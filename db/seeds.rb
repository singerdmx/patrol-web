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

# asset1 = Asset.create({
#                 barcode: "GXWY1408291010001",
#                 name: "甲进线",
#                 description: "甲进线 GXWY1408291010001" })
# asset1.check_points.create([
#                 {
#                    name:         "电压（KV）ab",
#                    description:  "测量",
#                    category:     20,
#                    choice:       '[]',
#                    frequency:    24
#                 },
#                 {
#                    name:         "电压（KV）bc",
#                    description:  "测量",
#                    category:     20,
#                    choice:       '[]',
#                    frequency:    24
#                 },
#                 {
#                   name:         "电压（KV）ca",
#                   description:  "测量",
#                   category:     20,
#                   choice:       '[]',
#                   frequency:    24
#                 } ])
#
# asset2 = Asset.create({
#                 barcode: "GXWY1408291010002",
#                 name: "甲进线",
#                 description: "甲进线 GXWY1408291010002" })
# asset2.check_points.create([
#                 {
#                    name:         "电流（A）a",
#                    description:  "测量",
#                    category:     20,
#                    choice:       '[]',
#                    frequency:    24
#                 },
#                 {
#                    name:         "电流（A）b",
#                    description:  "测量",
#                    category:     20,
#                    choice:       '[]',
#                    frequency:    24
#                 },
#                 {
#                    name:         "电流（A）c",
#                    description:  "测量",
#                    category:     20,
#                    choice:       '[]',
#                    frequency:    24
#                 } ])
#
#
# route1 = area1.check_routes.create!(
#     {name: "高配电设备巡检（二路进线配电房）", description: "高配电设备巡检（二路进线配电房）"})
# route1.check_points << asset1.check_points
# route1.check_points << asset2.check_points
#
#
# #adding preference points
# user1.preferred_points <<  asset1.check_points
# user1.preferred_points <<  asset2.check_points
#
# #adding user to route
# route1.users << user1


asset01 = Asset.create({
                           serialnum: "GXWY1408291020016",
                           barcode: "GXWY1408291020016",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "生活泵",
                           description: "生活泵" })
asset01.check_points.create([
                                {
                                    name:         "1号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset02 = Asset.create({
                           serialnum: "GXWY1408291020017",
                           barcode: "GXWY1408291020017",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "喷淋泵",
                           description: "喷淋泵" })
asset02.check_points.create([
                                {
                                    name:         "1号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset03 = Asset.create({
                           serialnum: "GXWY1408291020018",
                           barcode: "GXWY1408291020018",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "消防泵",
                           description: "消防泵" })
asset03.check_points.create([
                                {
                                    name:         "1号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset04 = Asset.create({
                           serialnum: "GXWY1408291020019",
                           barcode: "GXWY1408291020019",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "集水井",
                           description: "集水井" })
asset04.check_points.create([
                                {
                                    name:         "1号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])
asset05 = Asset.create({
                           serialnum: "GXWY1408291020020",
                           barcode: "GXWY1408291020020",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "双切电源",
                           description: "双切电源" })
asset05.check_points.create([
                                {
                                    name:         "生活",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "消防",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset06 = Asset.create({
                           serialnum: "GXWY1408291020021",
                           barcode: "GXWY1408291020021",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "控 制 柜",
                           description: "控 制 柜" })
asset06.check_points.create([
                                {
                                    name:         "生活",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "消防",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "喷淋",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "液位器",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "排污",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset07 = Asset.create({
                           serialnum: "GXWY1408291020022",
                           barcode: "GXWY1408291020022",                           serialnum: SecureRandom.urlsafe_base64(10),
                           name: "水泵房",
                           description: "水泵房" })
asset07.check_points.create([
                                {
                                    name:         "压力表",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "管道阀门",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机房照明",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "环境卫生",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "消防设备",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "水箱浮球阀",
                                    description:  "是否正常",
                                    category:     40,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])



route0 = area1.check_routes.create!(
    {name: "水泵房巡视", description: "水泵房巡视"})
route0.check_points << asset01.check_points
route0.check_points << asset02.check_points
route0.check_points << asset03.check_points
route0.check_points << asset04.check_points
route0.check_points << asset05.check_points
route0.check_points << asset06.check_points
route0.check_points << asset07.check_points


#adding preference points
user1.preferred_points <<  asset01.check_points
user1.preferred_points <<  asset02.check_points

#adding user to route
route0.users << user1



asset1 = Asset.create({
                          serialnum: "GXWY1408291030023",
                          barcode: "GXWY1408291030023",
                          name: "设备",
                          description: "设备" })
asset1.check_points.create([
                               {
                                   name:         "控制系统",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "拽引器",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "限速器",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "轿厢门厅",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "应急对讲",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               } ])

asset2 = Asset.create({
                          serialnum: "GXWY1408291030024",
                          barcode: "GXWY1408291030024",
                          name: "机房",
                          description: "机房" })
asset2.check_points.create([
                               {
                                   name:         "井道机房照明",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "消防设施",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               },
                               {
                                   name:         "室内温度",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     20,
                                   choice:       '[]',
                                   frequency:    336
                               },
                               {
                                   name:         "环境卫生",
                                   description:  "是否正常",
                                   state:        "运转",
                                   category:     40,
                                   choice:       '["正常","异常"]',
                                   frequency:    336
                               } ])


route1 = area1.check_routes.create!(
    {name: "电梯机房设备保养", description: "电梯机房设备保养"})
route1.check_points << asset1.check_points
route1.check_points << asset2.check_points


#adding preference points
user1.preferred_points <<  asset1.check_points
user1.preferred_points <<  asset2.check_points

#adding user to route
route1.users << user1
