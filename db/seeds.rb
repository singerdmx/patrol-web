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

user2 = User.create! do |u|
  u.email = 'user1@shibei.com'
  u.password = 'shibei1234'
  u.password_confirmation = 'shibei1234'
  u.role = 2
  u.name = "User1"
  #u.ensure_authentication_token!
end

user3 = User.create! do |u|
  u.email = 'user2@shibei.com'
  u.password = 'shibei1234'
  u.password_confirmation = 'shibei1234'
  u.role = 2
  u.name = "User2"
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
#                 barcode: "WY141010001",
#                 name: "甲进线",
#                 description: "甲进线 WY141010001" })
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
#                 barcode: "WY141010002",
#                 name: "甲进线",
#                 description: "甲进线 WY141010002" })
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



asset21 = Asset.create({
                           serialnum: "WY141010001",
                           barcode: "WY141010001",
                           name: "甲进线",
                           description: "甲进线" })
asset21.check_points.create([
                                {
                                    name:         "功率因数",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器温度",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）ab",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）bc",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）ca",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）a",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）b",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "变压器运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）c",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电压（KV）ab",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线器电压（KV）bc",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电压（KV）ca",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）a",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）b",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "变压器运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）c",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset23 = Asset.create({
                           serialnum: "WY141010003",
                           barcode: "WY141010003",
                           name: "乙进线",
                           description: "乙进线" })
asset23.check_points.create([
                                {
                                    name:         "功率因数",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器温度",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）ab",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）bc",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电压（KV）ca",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）a",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）b",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "变压器运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "变压器电流（A）c",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电压（KV）ab",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线器电压（KV）bc",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电压（KV）ca",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）a",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:10,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）b",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "变压器运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "进线电流（A）c",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    default_value:12,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset26 = Asset.create({
                           serialnum: "WY141010006",
                           barcode: "WY141010006",
                           name: "上墙资料、劳防及用具",
                           description: "上墙资料、劳防及用具" })

asset26.check_points.create([
                                {
                                    name:         "绝缘手套",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "绝缘鞋",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "高压验电笔",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "接地线",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "外来人员进出登记表",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "缺陷记录表",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "清洁用具",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset35 = Asset.create({
                           serialnum: "WY141010015",
                           barcode: "WY141010015",
                           name: "配电房",
                           description: "配电房" })
asset35.check_points.create([
                                {
                                    name:         "室内温度（T）",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "室内湿度（%）",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机房照明",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "应急照明",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "灭火器有效期",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机房灭火器压力表",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["绿","黄","红"]',
                                    frequency:    24
                                } ])

route2 = area1.check_routes.create!(
    {name: "高配电设备巡检（二路进线配电房）", description: "高配电设备巡检（二路进线配电房）"})
route2.check_points << asset21.check_points
route2.check_points << asset23.check_points
route2.check_points << asset26.check_points
route2.check_points << asset35.check_points

#adding preference points
user1.preferred_points << asset21.check_points
user1.preferred_points << asset23.check_points
user1.preferred_points << asset26.check_points
user1.preferred_points << asset35.check_points

user2.preferred_points << asset21.check_points
user2.preferred_points << asset23.check_points
user2.preferred_points << asset26.check_points
user2.preferred_points << asset35.check_points

user3.preferred_points << asset21.check_points
user3.preferred_points << asset23.check_points
user3.preferred_points << asset26.check_points
user3.preferred_points << asset35.check_points

#adding user to route
route2.users << user1
route2.users << user2
route2.users << user3

asset01 = Asset.create({
                           serialnum: "WY141020016",
                           barcode: "WY141020016",
                           name: "生活水泵",
                           description: "生活水泵" })
asset01.check_points.create([
                                {
                                    name:         "1号泵泵体",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "1号泵管道压力表",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "1号泵管道油漆",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "1号泵管道阀门",
                                    description:  "开闭情况",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["开","闭"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号泵泵体",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号泵管道压力表",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号泵管道油漆",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "2号泵管道阀门",
                                    description:  "开闭情况",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["开","闭"]',
                                    frequency:    24
                                },
                                {
                                    name:         "控制柜指示灯",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset02 = Asset.create({
                           serialnum: "WY141020017",
                           barcode: "WY141020017",
                           name: "消防湿式报警阀组",
                           description: "消防湿式报警阀组" })
asset02.check_points.create([
                                {
                                    name:         "阀组阀门",
                                    description:  "开闭情况",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["开","闭"]',
                                    frequency:    24
                                },
                                {
                                    name:         "泄水管情况",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "阀组压力表读数",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset03 = Asset.create({
                           serialnum: "WY141020018",
                           barcode: "WY141020018",
                           name: "水箱",
                           description: "水箱" })
asset03.check_points.create([
                                {
                                    name:         "水箱浮球阀",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "水箱外立面",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "水箱泄水管情况",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "水箱盖是否上锁",
                                    description:  "是否上锁",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["是","否"]',
                                    frequency:    24
                                } ])

asset04 = Asset.create({
                           serialnum: "WY141020019",
                           barcode: "WY141020019",
                           name: "集水井",
                           description: "集水井" })
asset04.check_points.create([
                                {
                                    name:         "控制柜指示灯",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "管道压力表",
                                    description:  "是否正常",
                                    category:     51,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "井内清洁",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "管道油漆",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "阀门开闭",
                                    description:  "开闭情况",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["开","闭"]',
                                    frequency:    24
                                } ])

asset05 = Asset.create({
                           serialnum: "WY141020020",
                           barcode: "WY141020020",
                           name: "水泵房其他情况",
                           description: "水泵房其他情况" })
asset05.check_points.create([
                                {
                                    name:         "上墙资料",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "清洁用具",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机房照明",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "灭火器有效期",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "灭火器压力表",
                                    description:  "是否正常",
                                    category:     41,
                                    state:        "运转",
                                    choice:       '["绿","黄","红"]',
                                    frequency:    24
                                } ])


route0 = area1.check_routes.create!(
    {name: "水泵房巡视", description: "水泵房巡视"})
route0.check_points << asset01.check_points
route0.check_points << asset02.check_points
route0.check_points << asset03.check_points
route0.check_points << asset04.check_points
route0.check_points << asset05.check_points


#adding preference points
user1.preferred_points <<  asset01.check_points
user2.preferred_points <<  asset01.check_points
user3.preferred_points <<  asset01.check_points
user1.preferred_points <<  asset02.check_points
user2.preferred_points <<  asset02.check_points
user3.preferred_points <<  asset02.check_points
user1.preferred_points <<  asset03.check_points
user2.preferred_points <<  asset03.check_points
user3.preferred_points <<  asset03.check_points
user1.preferred_points <<  asset04.check_points
user2.preferred_points <<  asset04.check_points
user3.preferred_points <<  asset04.check_points
user1.preferred_points <<  asset05.check_points
user2.preferred_points <<  asset05.check_points
user3.preferred_points <<  asset05.check_points

#adding user to route
route0.users << user1
route0.users << user2
route0.users << user3



asset1 = Asset.create({
                          serialnum: "WY141030023",
                          barcode: "WY141030023",
                          name: "电梯设备",
                          description: "电梯设备" })
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
                          serialnum: "WY141030024",
                          barcode: "WY141030024",
                          name: "电梯机房",
                          description: "电梯机房" })
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
                                   category:     51,
                                   default_value:20,
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
user2.preferred_points <<  asset1.check_points
user2.preferred_points <<  asset2.check_points
user3.preferred_points <<  asset1.check_points
user3.preferred_points <<  asset2.check_points

#adding user to route
route1.users << user1
route1.users << user2
route1.users << user3
