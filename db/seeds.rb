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
                barcode: "1021",
                number: SecureRandom.random_number(5),
                serialnum: SecureRandom.urlsafe_base64(10),
                description: "轧机电机" })
site1 = SecureRandom.random_number(500)
asset1.check_points.create([
                { site_id:      site1,
                  description:  "轴承",
                  cstm_tpmid:   SecureRandom.random_number(300),
                  tpm_type:     "温度",
                  period:       1,
                  period_unit:  'D',
                  status:       "运转",
                  standard:     "<= 70" },
                { site_id:      site1,
                  description:  "轴承",
                  cstm_tpmid:   SecureRandom.random_number(300),
                  tpm_type:     "震动",
                  period:       1,
                  period_unit:  'D',
                  status:       "运转",
                  standard:     "<= 2" } ])

asset2 = Asset.create({
                          tag: SecureRandom.urlsafe_base64(10),
                          barcode: "2022",
                          number: SecureRandom.random_number(5),
                          serialnum: SecureRandom.urlsafe_base64(10),
                          description: "轧机联轴器" })
site2 = SecureRandom.random_number(500)
asset2.check_points.create([
               { site_id:      site2,
                 description:  "安全销",
                 cstm_tpmid:   SecureRandom.random_number(300),
                 tpm_type:     "断裂",
                 period:       1,
                 period_unit:  'D',
                 status:       "停止",
                 standard:     "未断裂" } ])

asset3 = Asset.create({
                          tag: SecureRandom.urlsafe_base64(10),
                          barcode: "3023",
                          number: SecureRandom.random_number(5),
                          serialnum: SecureRandom.urlsafe_base64(10),
                          description: "轧机减速机" })
site3 = SecureRandom.random_number(500)
asset3.check_points.create([
               { site_id:      site3,
                 description:  "输入端轴承",
                 cstm_tpmid:   SecureRandom.random_number(300),
                 tpm_type:     "震动",
                 period:       1,
                 period_unit:  'D',
                 status:       "运转",
                 standard:     "<= 2" },
               { site_id:      site3,
                 description:  "输入端轴承",
                 cstm_tpmid:   SecureRandom.random_number(300),
                 tpm_type:     "温度",
                 period:       1,
                 period_unit:  'D',
                 status:       "运转",
                 standard:     "<= 70" },
               { site_id:      site3,
                 description:  "输出端轴承",
                 cstm_tpmid:   SecureRandom.random_number(300),
                 tpm_type:     "温度",
                 period:       1,
                 period_unit:  'D',
                 status:       "运转",
                 standard:     "<= 70" },
               { site_id:      site3,
                 description:  "箱体",
                 cstm_tpmid:   SecureRandom.random_number(300),
                 tpm_type:     "声音",
                 period:       1,
                 period_unit:  'D',
                 status:       "运转",
                 standard:     "运转平稳，无杂音" } ])

route1 = CheckRoute.create!({description: "一工区机械8小时点巡检"})
route1.assets << asset1
route1.assets << asset2
route1.assets << asset3

route2 = CheckRoute.create!({description: "二工区机械8小时点巡检"})
route2.assets << asset1

route3 = CheckRoute.create!({description: "三工区机械8小时点巡检"})
route3.assets << asset2
route3.assets << asset3

CheckResult.create({result: 'pass', check_route_id:1,  check_point_id: 2, session: 34})
CheckResult.create({result: 'fail', check_route_id:1,  check_point_id: 3, session: 34})
CheckResult.create({result: 'pass', check_route_id:2,  check_point_id: 1, session: 444})
CheckResult.create({result: 'fail', check_route_id:2,  check_point_id: 2, session: 444})



