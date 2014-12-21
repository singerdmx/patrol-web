require 'json'

Factory.delete_all
Subfactory.delete_all
Area.delete_all

factory = Factory.create({name: "工厂"})

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




asset01 = Asset.create({
                           serialnum: "2222101001",
                           barcode: "2222101001",
                           name: "左侧拆车门机械手",
                           description: "左侧拆车门机械手" })
asset01.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查活动关节运动是否顺畅",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查设备在轨道中运行是否顺畅",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查越位开关功能是否正常",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查设备气源管和接头是否漏气",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查气压表显示气压值是否在压力范围内",
                                    category:     50,
                                    state:        "",
                                    choice:       '["0.45", "", "", "0.55"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])


asset02 = Asset.create({
                           serialnum: "2222101002",
                           barcode: "2222101002",
                           name: "右侧拆车门机械手",
                           description: "右侧拆车门机械手" })
asset02.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查活动关节运动是否顺畅",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查设备在轨道中运行是否顺畅",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查越位开关功能是否正常",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查设备气源管和接头是否漏气",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查气压表显示气压值是否在压力范围内",
                                    category:     50,
                                    state:        "",
                                    choice:       '["0.45", "", "", "0.55"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset03 = Asset.create({
                           serialnum: "2222101003",
                           barcode: "2222101003",
                           name: "VIN码打码设备",
                           description: "VIN码打码设备" })
asset03.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查定位销是否有损坏",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查夹紧机构尼龙块是否磨损",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查打码头是否有损坏",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查气管与设备是否干涉，是否有磨损",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "电气部分",
                                    description:  "检查电控柜是否能够正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset04 = Asset.create({
                           serialnum: "2222101004",
                           barcode: "2222101004",
                           name: "温控机",
                           description: "温控机" })
asset04.check_points.create([
                                {
                                    name:         "温控机",
                                    description:  "状态正常绿灯是否常亮",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "温控机",
                                    description:  "按钮功能是否正常",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "温控机",
                                    description:  "电压是否在标准范围内",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "温控机",
                                    description:  "电流是否在标准范围内",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "温控机",
                                    description:  "温度是否在标准范围内",
                                    category:     50,
                                    state:        "",
                                    choice:       '["0.45", "", "", "0.55"]',
                                    frequency:    24
                                } ])

asset05 = Asset.create({
                           serialnum: "2222101005",
                           barcode: "2222101005",
                           name: "天线压装助力机械手",
                           description: "天线压装助力机械手" })
asset05.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查定位销是否有损坏",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查设备在轨道中运行是否顺畅",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查越位开关功能是否正常",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查定位丝杆上下限位螺母位置是否有变化",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查设备气源管和接头是否漏气",
                                    category:     50,
                                    state:        "",
                                    choice:       '["0.45", "", "", "0.55"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

asset06 = Asset.create({
                           serialnum: "2222101006",
                           barcode: "2222101006",
                           name: "天窗安装助力机械手",
                           description: "天窗安装助力机械手" })
asset06.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查定位丝杆上下限位螺母位置有无变化",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查定位销有无明显弯曲",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "机械本体",
                                    description:  "检查设备在轨道中是否运行顺畅，无卡滞",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查越位开关功能是否正常",
                                    category:     50,
                                    state:        "",
                                    choice:       '["0.45", "", "", "0.55"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查设备气源管和接头有无漏气",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])


asset07 = Asset.create({
                           serialnum: "2222101007",
                           barcode: "2222101007",
                           name: "天窗调整助力机械手",
                           description: "天窗调整助力机械手" })
asset07.check_points.create([
                                {
                                    name:         "机械本体",
                                    description:  "检查活动关节是否可以运动顺畅，无卡滞",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "驱动机构",
                                    description:  "检查气源管路有无漏气",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "执行机构",
                                    description:  "检查按钮是否可以正常使用",
                                    category:     41,
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                } ])

route001 = area1.check_routes.create!(
    {name: "TRIM1线TPM", description: "TRIM1线TPM"})
route001.check_points << asset01.check_points
route001.check_points << asset02.check_points
route001.check_points << asset03.check_points
route001.check_points << asset04.check_points
route001.check_points << asset05.check_points
route001.check_points << asset06.check_points
route001.check_points << asset07.check_points


user1.preferred_points <<  asset01.check_points
user3.preferred_points <<  asset01.check_points
user1.preferred_points <<  asset02.check_points
user3.preferred_points <<  asset02.check_points
user1.preferred_points <<  asset03.check_points
user3.preferred_points <<  asset03.check_points
user1.preferred_points <<  asset04.check_points
user3.preferred_points <<  asset04.check_points
user1.preferred_points <<  asset05.check_points
user3.preferred_points <<  asset05.check_points
user1.preferred_points <<  asset06.check_points
user3.preferred_points <<  asset06.check_points
user1.preferred_points <<  asset07.check_points
user3.preferred_points <<  asset07.check_points

route001.users << user1
route001.users << user3






