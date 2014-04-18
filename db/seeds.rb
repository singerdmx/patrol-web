# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'securerandom'

#route_descriptions = ['一工区机械8小时点巡检', '二工区机械8小时点巡检','三工区机械8小时点巡检' ]
#asset_descriptions = ['轧机电机','轧机联轴器','轧机减速机']
#point_descriptions = ['轴承','箱体','安全销','输入端轴承','输出端轴承']
#tpm_types = ['震动','温度','声音','断裂']
#asset_status = ['运转','停止']
#point_standard = ['<=70', '安静']

CheckRoute.delete_all
Asset.delete_all
CheckPoint.delete_all
CheckResult.delete_all

#create routes based on 17-1.pdf page 9
asset1 = Asset.create({
                tag: SecureRandom.urlsafe_base64(10),
                barcode: "780672318863",
                number: SecureRandom.random_number(5),
                serialnum: SecureRandom.urlsafe_base64(10),
                description: "轧机电机" })
site1 = SecureRandom.random_number(500)
asset1.check_points.create([
                {
                  name:         "轴承",
                  description:  "温度测量",
                  state:        "运转",
                  category:         50,
                  choice:       '["", "", "", "70"]',
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
                          description: "轧机联轴器" })
site2 = SecureRandom.random_number(500)
asset2.check_points.create([
               {
                 name:         "轧机联轴器",
                 description:  "检查安全销",
                 barcode:      "780672318812",
                 state:        "停止",
                 category:         41,
                 choice:       '["正常", "非正常"]',
               } ])

asset3 = Asset.create({
                          tag: SecureRandom.urlsafe_base64(10),
                          barcode: "780672318890",
                          number: SecureRandom.random_number(5),
                          serialnum: SecureRandom.urlsafe_base64(10),
                          description: "轧机减速机" })
site3 = SecureRandom.random_number(500)
asset3.check_points.create([
               { name:         "输入端轴承",
                 description:  "温度测量",
                 state:        "运转",
                 category:         50,
                 choice:       '["", "", "", "70"]',
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
                 choice:       '["安静", "异常"]',
               } ])

route1 = CheckRoute.create!({description: "一工区机械8小时点巡检"})
route1.check_points << asset1.check_points.first
route1.check_points << asset2.check_points.first
route1.check_points << asset3.check_points.first

route2 = CheckRoute.create!({description: "二工区机械8小时点巡检"})
route2.check_points << asset1.check_points.last

route3 = CheckRoute.create!({description: "三工区机械8小时点巡检"})
route3.check_points << asset2.check_points.last
route3.check_points << asset3.check_points.first
route3.check_points << asset3.check_points.last

session1 = CheckSession.create!({check_route_id: 1, start_time: '2014-04-01 15:53:29 -0700', end_time: '2014-04-02 15:53:29 -0700', user:'joel', session: '34324ar'})
session2 = CheckSession.create!({check_route_id: 2, start_time: '2014-03-01 15:53:29 -0700', end_time: '2014-03-02 15:53:29 -0700', user:'ben', session: 'erewr43'})
session3 = CheckSession.create!({check_route_id: 3, start_time: '2013-04-01 15:53:29 -0700', end_time: '2013-04-02 15:53:29 -0700', user:'alex', session: '2243dg'})

route1.check_sessions << session1
route1.check_sessions << session2
route1.check_sessions << session3

route2.check_sessions << session1
route2.check_sessions << session2

route3.check_sessions << session3

CheckResult.create({result: 'pass', check_session_id:1,  check_point_id: 2,  value: 'sdd', check_time: '2014-04-02 15:53:29 -0700'})
CheckResult.create({result: 'fail', check_session_id:1,  check_point_id: 3,  value: 'sdfdsf', check_time: '2011-04-02 15:53:29 -0700'})
CheckResult.create({result: 'pass', check_session_id:2,  check_point_id: 1,  value: 'trtt', check_time: '2010-04-02 15:53:29 -0700'})
CheckResult.create({result: 'fail', check_session_id:2,  check_point_id: 2,  value: 'gbfgg', check_time: '2019-04-02 15:53:29 -0700'})



