# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'securerandom'
require 'json'

#route_descriptions = ['一工区机械8小时点巡检', '二工区机械8小时点巡检','三工区机械8小时点巡检' ]
#asset_descriptions = ['轧机电机','轧机联轴器','轧机减速机']
#point_descriptions = ['轴承','箱体','安全销','输入端轴承','输出端轴承']
#tpm_types = ['震动','温度','声音','断裂']
#asset_status = ['运转','停止']
#point_standard = ['<=70', '安静']
check_point_3_choice = '["正常", "非正常"]'
check_point_7_choice = '["安静","轻微噪音","大幅杂音","异常"]'

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
  u.email = 'user2@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 2
  u.name = "u2"
  #u.ensure_authentication_token!
end

user3 = User.create! do |u|
  u.email = 'user3@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 1
  u.name = 'leader'
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

#create routes based on 17-1.pdf page 9
asset1 = Asset.create({
                tag: SecureRandom.urlsafe_base64(10),
                barcode: "780672318863",
                number: SecureRandom.random_number(5),
                serialnum: SecureRandom.urlsafe_base64(10),
                name: "轧机电机",
                description: "轧机电机" })
site1 = SecureRandom.random_number(500)
asset1.check_points.create([
                {
                  name:         "轴承",
                  description:  "温度测量",
                  state:        "运转",
                  category:         50,
                  choice:       '["", "", "", "70"]',
                  frequency:   24*3
                },
                {
                  name:         "轴承",
                  description:  "振动测量",
                  state:        "运转",
                  category:         50,
                  choice:       '["", "", "", "4"]',
                } ])

asset2 = Asset.create({
                          tag: SecureRandom.urlsafe_base64(10),
                          number: SecureRandom.random_number(5),
                          serialnum: SecureRandom.urlsafe_base64(10),
                          barcode:     "780672318812",
                          name: "轧机联轴器",
                          description: "轧机联轴器" })
site2 = SecureRandom.random_number(500)
asset2.check_points.create([
               {
                 name:         "轧机联轴器",
                 description:  "检查安全销",
                 barcode:      "780672318812",
                 state:        "停止",
                 category:         41,
                 choice:       check_point_3_choice,
               } ])

asset3 = Asset.create({
                          tag: SecureRandom.urlsafe_base64(10),
                          barcode: "780672318890",
                          number: SecureRandom.random_number(5),
                          serialnum: SecureRandom.urlsafe_base64(10),
                          name: "轧机减速机",
                          description: "轧机减速机" })
site3 = SecureRandom.random_number(500)
asset3.check_points.create([
               { name:         "输入端轴承",
                 description:  "温度测量",
                 state:        "运转",
                 category:         50,
                 barcode:      "999972318875",
                 choice:       '["20", "30", "60", "70"]',
               },
               { name:         "输入端轴承",
                 description:  "振动测量",
                 state:        "运转",
                 category:         50,
                 choice:       '["", "", "", "4"]',
               },
               {
                 barcode:      "999972318873",
                 name:         "输出端轴承",
                 description:  "温度测量",
                 state:        "运转",
                 category:         50,
                 choice:       '["", "", "", "70"]',
               },
               {
                 barcode:      "999972318812",
                 name:         "箱体",
                 description:  "噪音检测",
                 state:        "运转",
                 category:         41,
                 choice:       check_point_7_choice,
               } ])

asset10 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188100",
                           name: "T40桶体",
                           description: "T40桶体" })
asset10.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188100",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])
asset11 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188101",
                           name: "T40桶体",
                           description: "T40桶体" })
asset11.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188101",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])
asset12 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188102",
                           name: "T40桶体",
                           description: "T40桶体" })
asset12.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188102",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])
asset13 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188103",
                           name: "T40桶体",
                           description: "T40桶体" })
asset13.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188103",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])
asset14 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188104",
                           name: "T40桶体",
                           description: "T40桶体" })
asset14.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188104",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])
asset15 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "1006723188105",
                           name: "T40桶体",
                           description: "T40桶体" })
asset15.check_points.create([
                                {
                                    name:         "T40桶体",
                                    description:  "巡更",
                                    barcode:      "1006723188105",
                                    state:        "运转",
                                    category:         10,
                                    choice:       '[]',
                                } ])

asset20 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "2006723188100",
                           name: "齿轮箱",
                           description: "齿轮箱" })
asset20.check_points.create([
                                {
                                    name:         "齿轮箱",
                                    description:  "润滑",
                                    barcode:      "2006723188100",
                                    state:        "运转",
                                    category:         20,
                                    choice:       '[]',
                                } ])
asset21 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "2006723188101",
                           name: "齿轮箱",
                           description: "齿轮箱" })
asset21.check_points.create([
                                {
                                    name:         "齿轮箱",
                                    description:  "润滑",
                                    barcode:      "2006723188101",
                                    state:        "运转",
                                    category:         20,
                                    choice:       '[]',
                                } ])
asset22 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "2006723188102",
                           name: "齿轮箱",
                           description: "齿轮箱" })
asset22.check_points.create([
                                {
                                    name:         "齿轮箱",
                                    description:  "润滑",
                                    barcode:      "2006723188102",
                                    state:        "运转",
                                    category:         20,
                                    choice:       '[]',
                                } ])

asset40 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "4006723188100",
                           name: "均质机1",
                           description: "均质机1" })
asset40.check_points.create([
                                {
                                    name:         "均质机1",
                                    description:  "状态",
                                    barcode:      "4006723188100",
                                    state:        "运转",
                                    category:         40,
                                    choice:       '["清洗", "除尘"]',
                                } ])
asset41 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "4006723188101",
                           name: "均质机1",
                           description: "均质机1" })
asset41.check_points.create([
                                {
                                    name:         "均质机1",
                                    description:  "状态",
                                    barcode:      "4006723188101",
                                    state:        "运转",
                                    category:         40,
                                    choice:       '["清洗", "除尘"]',
                                } ])

asset30 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "3006723188100",
                           name: "电表1",
                           description: "电表1" })
asset30.check_points.create([
                                {
                                    name:         "电表1",
                                    description:  "抄表",
                                    barcode:      "3006723188100",
                                    state:        "运转",
                                    category:         30,
                                    choice:       '[]',
                                } ])
asset31 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "3006723188101",
                           name: "电表2",
                           description: "电表2" })
asset31.check_points.create([
                                {
                                    name:         "电表2",
                                    description:  "抄表",
                                    barcode:      "",
                                    state:        "运转",
                                    category:         30,
                                    choice:       '[]',
                                } ])

asset32 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "3006723188101",
                           name: "电表32",
                           description: "电表32" })
asset32.check_points.create([
                                {
                                    name:         "电表32",
                                    description:  "抄表",
                                    barcode:      "",
                                    state:        "运转",
                                    category:         30,
                                    choice:       '[]',
                                } ])

asset32 = Asset.create({
                           tag: SecureRandom.urlsafe_base64(10),
                           number: SecureRandom.random_number(5),
                           serialnum: SecureRandom.urlsafe_base64(10),
                           barcode:     "",
                           name: "电表32",
                           description: "电表32" })
asset32.check_points.create([
                                {
                                    name:         "电表32",
                                    description:  "抄表",
                                    barcode:      "",
                                    state:        "运转",
                                    category:         30,
                                    choice:       '[]',
                                } ])

route1 = CheckRoute.create!(
    {name: "一工区机械8小时点巡检", description: "一工区机械8小时点巡检"})
route1.check_points << asset1.check_points.first
route1.check_points << asset2.check_points.first
route1.check_points << asset3.check_points.first


route2 = CheckRoute.create!(
    {name: "二工区机械8小时点巡检", description: "二工区机械8小时点巡检"})
route2.check_points << asset1.check_points.last


#adding preference points
user1.preferred_points <<  asset1.check_points.last
user1.preferred_points <<  asset3.check_points.first

route3 = CheckRoute.create!(
    {name: "三工区机械8小时点巡检", description: "三工区机械8小时点巡检"})
route3.check_points << asset2.check_points.last
route3.check_points << asset3.check_points.first
route3.check_points << asset3.check_points.last



route4 = CheckRoute.create!(
    {name: "调配前处理区生产前点巡检", description: "调配前处理区生产前点巡检"})
route4.check_points << asset10.check_points.first
route4.check_points << asset11.check_points.first
route4.check_points << asset12.check_points.first
route4.check_points << asset13.check_points.first
route4.check_points << asset14.check_points.first
route4.check_points << asset15.check_points.first


route5 = CheckRoute.create!(
    {name: "调配前处理区润滑巡检", description: "调配前处理区润滑巡检"})
route5.check_points << asset20.check_points.first
route5.check_points << asset21.check_points.first
route5.check_points << asset22.check_points.first


route6 = CheckRoute.create!(
    {name: "调配前处理区清洗巡检", description: "调配前处理区清洗巡检"})
route6.check_points << asset40.check_points.first
route6.check_points << asset41.check_points.first


route7 = CheckRoute.create!(
    {name: "调配前处理区抄表巡检", description: "调配前处理区抄表巡检"})
route7.check_points << asset30.check_points.first
route7.check_points << asset31.check_points.first

route8 = CheckRoute.create!(
    {name: "调配前处理区抄表巡检", description: "调配前处理区抄表巡检"})
route8.check_points << asset31.check_points.first
route8.check_points << asset32.check_points.first

route1.users << user1
route2.users << user1
route3.users << user1
route4.users << user1
route5.users << user2
route6.users << user2
route7.users << user2
route8.users << user3


session1 = route1.check_sessions.create!(
    {
     start_time: "2014-04-29 06:36:09.0",
     end_time: "2014-04-29 06:42:53.0",
     user:'user@test.com',
     session: '34ed3eb-36e6-445d-a9f7-79f4577c033d',
     created_at: "2014-04-29 06:47:34.740",
     updated_at: "2014-04-29 06:47:34.740"
    })
session2 = route2.check_sessions.create!(
    {
     start_time: "2014-04-29 06:36:09.0",
     end_time: "2014-04-29 06:42:53.0",
     user:'user@test.com',
     session: 'b34ed3eb-36e6-445d-a9f7-79f4577c033d',
     created_at: "2014-04-29 06:47:34.758",
     updated_at: "2014-04-29 06:47:34.758"
    })
session3 = route3.check_sessions.create!(
    {
     start_time: "2014-04-29 06:36:09.0",
     end_time: "2014-04-29 06:42:53.0",
     user:'user@test.com',
     session: 'b34ed3eb-36e6-445d-a9f7-79f4577c033d',
     created_at: "2014-04-29 06:47:34.774",
     updated_at: "2014-04-29 06:47:34.774"
    })
session4 = route4.check_sessions.create!(
    {
     start_time: "2014-04-29 06:43:08.0",
     end_time: "2014-04-29 06:45:26.0",
     user:'user@test.com',
     session: '0a5764f4-1170-4b34-904c-fc8b2c6d5592',
     created_at: "2014-04-29 06:47:34.864",
     updated_at: "2014-04-29 06:47:34.864"
    })
session5 = route5.check_sessions.create!(
    {
     start_time: "2014-04-29 06:43:08.0",
     end_time: "2014-04-29 06:45:26.0",
     user:'user@test.com',
     session: '0a5764f4-1170-4b34-904c-fc8b2c6d5592',
     created_at: "2014-04-29 06:47:34.873",
     updated_at: "2014-04-29 06:47:34.873"
    })
session6 = route6.check_sessions.create!(
    {
     start_time: "2014-04-29 06:43:08.0",
     end_time: "2014-04-29 06:45:26.0",
     user:'user@test.com',
     session: '0a5764f4-1170-4b34-904c-fc8b2c6d5592',
     created_at: "2014-04-29 06:47:34.882",
     updated_at: "2014-04-29 06:47:34.882"
    })
session7 = route7.check_sessions.create!(
    {
     start_time: "2014-04-29 06:45:39.0",
     end_time: "2014-04-29 06:47:36.0",
     user:'user@test.com',
     session: '515fc0e0-0506-404a-b9d3-9c56744f2232',
     created_at: "2014-04-29 06:47:34.951",
     updated_at: "2014-04-29 06:47:34.951"
    })
session8 = route8.check_sessions.create!(
    {
     start_time: "2014-04-29 06:45:39.0",
     end_time: "2014-04-29 06:47:36.0",
     user:'user@test.com',
     session: '515fc0e0-0506-404a-b9d3-9c56744f2232',
     created_at: "2014-04-29 06:47:34.963",
     updated_at: "2014-04-29 06:47:34.963"
    })


session4.check_results.create(
    {result: "70",
     status: 0,
     memo: "hot",
     check_time: "2014-04-29 06:39:41.0",
     check_point_id: route4.check_points.first.id,
     created_at: "2014-04-29 06:47:34.747",
     updated_at: "2014-04-29 06:47:34.747"
    })
session4.check_results.create(
    {result: "60",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:40:12.0",
     check_point_id: route4.check_points.limit(4).last.id,
     created_at: "2014-04-29 06:47:34.747",
     updated_at: "2014-04-29 06:47:34.747"
    })
session4.check_results.create(
    {result: "正常",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:40:27.0",
     check_point_id: route4.check_points.limit(3).last.id,
     created_at: "2014-04-29 06:47:34.755",
     updated_at: "2014-04-29 06:47:34.755"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:40:46.0",
     check_point_id: route5.check_points.first.id,
     created_at: "2014-04-29 06:47:34.760",
     updated_at: "2014-04-29 06:47:34.760"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:41:10.0",
     check_point_id: route5.check_points.limit(2).last.id,
     created_at: "2014-04-29 06:47:34.763",
     updated_at: "2014-04-29 06:47:34.763"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:41:20.0",
     check_point_id: route5.check_points.limit(3).last.id,
     created_at: "2014-04-29 06:47:34.765",
     updated_at: "2014-04-29 06:47:34.765"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-05-01 06:41:29.0",
     check_point_id: route5.check_points.limit(3).last.id,
     created_at: "2014-05-01 06:47:34.767",
     updated_at: "2014-05-01 06:47:34.767"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-05-02 06:41:48.0",
     check_point_id: route5.check_points.limit(3).last.id,
     created_at: "2014-05-02 06:47:34.770",
     updated_at: "2014-04-02 06:47:34.770"
    })
session5.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:41:55.0",
     check_point_id: route5.check_points.limit(3).last.id,
     created_at: "2014-04-29 06:47:34.772",
     updated_at: "2014-04-29 06:47:34.772"
    })
session6.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:42:33.0",
     check_point_id: 15,
     created_at: "2014-04-29 06:47:34.776",
     updated_at: "2014-04-29 06:47:34.776"
    })
session6.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:42:24.0",
     check_point_id: 14,
     created_at: "2014-04-29 06:47:34.779",
     updated_at: "2014-04-29 06:47:34.779"
    })
session6.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:42:45.0",
     check_point_id: 16,
     created_at: "2014-04-29 06:47:34.781",
     updated_at: "2014-04-29 06:47:34.781"
    })
session7.check_results.create(
    {result: "安静",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:43:38.0",
     check_point_id: 7,
     created_at: "2014-04-29 06:47:34.866",
     updated_at: "2014-04-29 06:47:34.866"
    })
session7.check_results.create(
    {result: "65",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:43:38.0",
     check_point_id: 4,
     created_at: "2014-04-29 06:47:34.869",
     updated_at: "2014-04-29 06:47:34.869"
    })
session7.check_results.create(
    {result: "正常",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:43:54.0",
     check_point_id: 3,
     created_at: "2014-04-29 06:47:34.871",
     updated_at: "2014-04-29 06:47:34.871"
    })
session8.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:44:30.0",
     check_point_id: 14,
     created_at: "2014-04-29 06:47:34.875",
     updated_at: "2014-04-29 06:47:34.875"
    })
session8.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:44:49.0",
     check_point_id: 15,
     created_at: "2014-04-29 06:47:34.878",
     updated_at: "2014-04-29 06:47:34.878"
    })
session8.check_results.create(
    {result: "",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:44:57.0",
     check_point_id: 16,
     created_at: "2014-04-29 06:47:34.880",
     updated_at: "2014-04-29 06:47:34.880"
    })
session1.check_results.create(
    {result: "正常",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:45:10.0",
     check_point_id: 17,
     created_at: "2014-04-29 06:47:34.884",
     updated_at: "2014-04-29 06:47:34.884"
    })
session1.check_results.create(
    {result: "正常",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:45:22.0",
     check_point_id: 18,
     created_at: "2014-04-29 06:47:34.886",
     updated_at: "2014-04-29 06:47:34.886"
    })
session2.check_results.create(
    {result: "异常",
     status: 1,
     memo: "",
     check_time: "2014-04-29 06:46:45.0",
     check_point_id: 7,
     created_at: "2014-04-29 06:47:34.954",
     updated_at: "2014-04-29 06:47:34.954"
    })
session2.check_results.create(
    {result: "正常",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:46:26.0",
     check_point_id: 3,
     created_at: "2014-04-29 06:47:34.957",
     updated_at: "2014-04-29 06:47:34.957"
    })
session2.check_results.create(
    {result: "59",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:46:45.0",
     check_point_id: 4,
     created_at: "2014-04-29 06:47:34.960",
     updated_at: "2014-04-29 06:47:34.960"
    })
session3.check_results.create(
    {result: "66",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:47:20.0",
     check_point_id: 19,
     created_at: "2014-04-29 06:47:34.965",
     updated_at: "2014-04-29 06:47:34.965"
    })
session3.check_results.create(
    {result: "50",
     status: 0,
     memo: "",
     check_time: "2014-04-29 06:47:34.0",
     check_point_id: 19,
     created_at: "2014-04-29 06:47:34.968",
     updated_at: "2014-04-29 06:47:34.968"
    })

check_point_3_choice_json = JSON.parse(check_point_3_choice)
(0..200).each do |i|
  now = Time.now
  session = route1.check_sessions.create!(
    {
      start_time: now - 3600 * 24 * 200,
      end_time: now,
      user:'user@test.com',
      session: SecureRandom.uuid,
    })

  check_time = now - i * 24 * 3600
  result = rand(100)
  if result > 70 || result < 20
    status = 1
  elsif result > 60 || result < 30
    status = 2
  else
    status = 0
  end

  session.check_results.create(
    {result: result,
     status: status,
     memo: "",
     check_time: check_time,
     check_point_id: 4,
    })

  check_time = now - i * 24 * 3600
  result = rand(check_point_3_choice_json.size())
  status = 1
  status = 0 if result == 0

  session.check_results.create(
    {result: check_point_3_choice_json[result],
     status: status,
     memo: "",
     check_time: check_time,
     check_point_id: 3,
    })
end

check_point_7_choice_json = JSON.parse(check_point_7_choice)
(0..200).each do |i|
  now = Time.now
  session = route3.check_sessions.create!(
    {
      start_time: now - 3600 * 24 * 200,
      end_time: now,
      user:'user@test.com',
      session: SecureRandom.uuid,
    })

  check_time = now - i * 24 * 3600
  result = rand(check_point_7_choice_json.size())
  status = 1
  status = 0 if result == 0

  session.check_results.create(
    {result: check_point_7_choice_json[result],
     status: status,
     memo: "",
     check_time: check_time,
     check_point_id: 7,
    })
end