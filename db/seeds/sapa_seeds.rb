require 'json'

Factory.delete_all
Subfactory.delete_all
Area.delete_all

factory = Factory.create({name: "工厂"})

subfactory1 = factory.subfactories.create( name: "分工厂 一" )

area1 = subfactory1.areas.create( name: "热轧线2" )

CheckRoute.delete_all
Asset.delete_all
CheckPoint.delete_all
CheckResult.delete_all
User.delete_all
Contact.delete_all
RepairReport.delete_all

user1 = User.create! do |u|
  u.email = 'userp1@test.com'
  u.password = 'user1234'
  u.password_confirmation = 'user1234'
  u.role = 2
  u.name = "巡检员1"
end

user3 = User.create! do |u|
  u.email = 'admin@test.com'
  u.password = 'admin1234'
  u.password_confirmation = 'admin1234'
  u.role = 0
  u.name = '管理员'
  #u.ensure_authentication_token!
end

user11 = User.create! do |c|
  c.name = "王月明"
  c.email = "yueming.wang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user12 = User.create! do |c|
  c.name = "汪敏"
  c.email = "min.wang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user13 = User.create! do |c|
  c.name = "陈杰"
  c.email = "jie.chen2@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user14 = User.create! do |c|
  c.name = "王耀忠"
  c.email = "yaozhong.wang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user15 = User.create! do |c|
  c.name = "张荣"
  c.email = "rong.zhang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user16 = User.create! do |c|
  c.name = "王强"
  c.email = "qiang.wang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user17 = User.create! do |c|
  c.name = "汪泳江"
  c.email = "yongjiang.wang@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end
user18 = User.create! do |c|
  c.name = "徐松"
  c.email = "song.xu@granges.com.cn"
  c.password = 'user1234'
  c.password_confirmation = 'user1234'
  c.role = 2
end


contact1 = Contact.create! do |c|
  c.name = "王月明"
  c.email = "yueming.wang@granges.com.cn"
end
contact2 = Contact.create! do |c|
  c.name = "汪敏"
  c.email = "min.wang@granges.com.cn"
end
contact3 = Contact.create! do |c|
  c.name = "陈杰"
  c.email = "jie.chen2@granges.com.cn"
end
contact4 = Contact.create! do |c|
  c.name = "王耀忠"
  c.email = "yaozhong.wang@granges.com.cn"
end
contact5 = Contact.create! do |c|
  c.name = "张荣"
  c.email = "rong.zhang@granges.com.cn"
end
contact6 = Contact.create! do |c|
  c.name = "王强"
  c.email = "qiang.wang@granges.com.cn"
end
contact7 = Contact.create! do |c|
  c.name = "汪泳江"
  c.email = "yongjiang.wang@granges.com.cn"
end
contact8 = Contact.create! do |c|
  c.name = "徐松"
  c.email = "song.xu@granges.com.cn"
end

asset01 = Asset.create({
                           serialnum: "1916201001",
                           barcode: "1916201001",
                           name: "出口操作侧对中",
                           description: "出口操作侧对中" })
asset01.check_points.create([
                                {
                                    name:         "出口操作侧对中床身",
                                    description:  "气囊压力及侧辊表面状况，侧辊表面无粘铝(<0.05Mpa)",
                                    category:     41,
                                    point_code:   "SC-1A100-MRSS04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口操作侧对中床身",
                                    description:  "立辊表面状况，立辊表面无粘铝",
                                    category:     41,
                                    point_code:   "SC-1A100-MRSV04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口操作侧对中油缸",
                                    description:  "头部和尾部油缸耳销是否松动。",
                                    category:     41,
                                    point_code:   "SC-1A000-MHYZ52",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])


asset02 = Asset.create({
                           serialnum: "1916201002",
                           barcode: "1916201002",
                           name: "出口传动侧对中",
                           description: "出口传动侧对中" })
asset02.check_points.create([
                                {
                                    name:         "出口传动侧对中床身",
                                    description:  "气囊压力及侧辊表面状况，侧辊表面无粘铝(<0.05Mpa)",
                                    category:     41,
                                    point_code:   "SC-19100-MRSS03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口传动侧对中床身",
                                    description:  "立辊表面状况，立辊表面无粘铝",
                                    category:     41,
                                    point_code:   "SC-19100-MRSV03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口传动侧对中油缸",
                                    description:  "头部和尾部油缸耳销是否松动。",
                                    category:     41,
                                    point_code:   "SC-19000-MHYZ51",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset03 = Asset.create({
                           serialnum: "1916201003",
                           barcode: "1916201003",
                           name: "出口卷取",
                           description: "出口卷取" })
asset03.check_points.create([
                                {
                                    name:         "出口卷取装置助卷器",
                                    description:  "钢带有无破损",
                                    category:     41,
                                    point_code:   "SC-1C400-MEWZ02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset04 = Asset.create({
                           serialnum: "1916201004",
                           barcode: "1916201004",
                           name: "出口液压剪液压站",
                           description: "出口液压剪液压站" })
asset04.check_points.create([
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-18100-EETU02",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["150", "", "", "165"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-18100-MEXZ07",
                                    measure_unit: "C",
                                    state:        "",
                                    choice:       '["", "", "", "55"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-18100-MEXZ07",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-18120-MPHR04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-18130-MPHR05",
                                    state:        "",
                                    default_assigned_id: user14.id,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "出口液压剪液压站",
                                    description:  "3＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-18140-MPHR06",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset05 = Asset.create({
                           serialnum: "1916201005",
                           barcode: "1916201005",
                           name: "传动轴",
                           description: "传动轴" })
asset05.check_points.create([
                                {
                                    name:         "传动轴",
                                    description:  "托辊运转状况，无卡阻",
                                    category:     41,
                                    point_code:   "SC-11500-MEZZ01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset06 = Asset.create({
                           serialnum: "1916201006",
                           barcode: "1916201006",
                           name: "地沟",
                           description: "地沟" })
asset06.check_points.create([
                                {
                                    name:         "地沟阀台",
                                    description:  "无明显漏油",
                                    category:     41,
                                    point_code:   "SC-10000-ZZZZ24",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "地沟管道",
                                    description:  "无明显漏油，油管无明显晃动",
                                    category:     41,
                                    point_code:   "SC-10000-ZZZZ24",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset07 = Asset.create({
                           serialnum: "1916201007",
                           barcode: "1916201007",
                           name: "辅助系统液压站",
                           description: "辅助系统液压站" })
asset07.check_points.create([
                                {
                                    name:         "辅助系统液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-1I100-EETU03",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["95", "", "", "105"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "辅助系统液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-1I100-MEXZ08",
                                    measure_unit: "C",
                                    state:        "",
                                    choice:       '["", "", "", "55"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "辅助系统液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-1I100-MEXZ08",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "辅助系统液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I120-MPHR07",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "辅助系统液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I130-MPHR08",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "辅助系统液压站",
                                    description:  "3＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I140-MPHR09",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset08 = Asset.create({
                           serialnum: "1916201008",
                           barcode: "1916201008",
                           name: "工作辊",
                           description: "工作辊" })
asset08.check_points.create([
                                {
                                    name:         "工作辊轴承座",
                                    description:  "润滑管无漏油漏气,管子无破损",
                                    category:     41,
                                    point_code:   "SC-11A10-MVVZ06",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset09 = Asset.create({
                           serialnum: "1916201009",
                           barcode: "1916201009",
                           name: "喷射梁",
                           description: "喷射梁" })
asset09.check_points.create([
                                {
                                    name:         "喷射梁",
                                    description:  "气压",
                                    category:     50,
                                    point_code:   "SC-11300-MVVZ03",
                                    measure_unit: "Mpa",
                                    state:        "",
                                    default_assigned_id: user13.id,
                                    choice:       '["0.40", "", "", ""]',
                                    frequency:    24
                                },
                                {
                                    name:         "喷射梁润滑单元",
                                    description:  "油箱油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-11300-MEXZ01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset10 = Asset.create({
                           serialnum: "1916201010",
                           barcode: "1916201010",
                           name: "热轧乳液地下室",
                           description: "热轧乳液地下室" })
asset10.check_points.create([
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查过滤泵管路",
                                    category:     41,
                                    point_code:   "SC-1J200-MVVZ42",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查1#循环泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J400-MPIC08",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查2#循环泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J400-MPIC09",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查1#过滤泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查2#过滤泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查3#过滤泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查4#过滤泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC14",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查1#供油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC05",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查2#供油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC06",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查3#供油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC07",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查4#供油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC15",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧乳液地下室",
                                    description:  "检查供油泵管路",
                                    category:     41,
                                    point_code:   "SC-1J300-MVVZ43",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset11 = Asset.create({
                           serialnum: "1916201011",
                           barcode: "1916201011",
                           name: "热轧稀油地下室",
                           description: "热轧稀油地下室" })
asset11.check_points.create([
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查主系统1#稀油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-11410-MPHG01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查主系统2#稀油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-11410-MPHG02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查主系统稀油泵管路",
                                    category:     41,
                                    point_code:   "SC-11410-MVVZ04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查立轧系统1#稀油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-12400-MPIC18",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查立轧系统2#稀油泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-12400-MPIC19",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "热轧稀油地下室",
                                    description:  "检查3#过滤泵泵头及电机轴承档外壳温度及振动",
                                    category:     41,
                                    point_code:   "SC-12400-MVVZ60",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset12 = Asset.create({
                           serialnum: "1916201012",
                           barcode: "1916201012",
                           name: "乳液过滤、循环系统",
                           description: "乳液过滤、循环系统" })
asset12.check_points.create([
                                {
                                    name:         "乳液过滤系统",
                                    description:  "1#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "乳液过滤系统",
                                    description:  "2#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "乳液过滤系统",
                                    description:  "3#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J200-MPIC04",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "乳液系统",
                                    description:  "自清洗过滤是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J000-MEFC01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "乳液循环系统",
                                    description:  "1＃泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J400-MPIC08",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "乳液循环系统",
                                    description:  "2＃泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J400-MPIC09",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])


asset13 = Asset.create({
                           serialnum: "1916201013",
                           barcode: "1916201013",
                           name: "入口操作侧对中",
                           description: "入口操作侧对中" })
asset13.check_points.create([
                                {
                                    name:         "入口操作侧对中床身",
                                    description:  "气囊压力及侧辊表面状况，侧辊表面无粘铝(<0.05Mpa)",
                                    category:     41,
                                    point_code:   "SC-15200-MRSS02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口操作侧对中床身",
                                    description:  "立辊表面状况，立辊表面无粘铝",
                                    category:     41,
                                    point_code:   "SC-15200-MRSV02",
                                    state:        "",
                                    default_assigned_id: user13.id,
                                    choice:       '["正常","异常"]',
                                    frequency:    24
                                },
                                {
                                    name:         "入口操作侧对中油缸",
                                    description:  "头部和尾部油缸耳销是否松动。",
                                    category:     41,
                                    point_code:   "SC-15000-MHYZ36",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])


asset14 = Asset.create({
                           serialnum: "1916201014",
                           barcode: "1916201014",
                           name: "入口传动侧对中",
                           description: "入口传动侧对中" })
asset14.check_points.create([
                                {
                                    name:         "入口传动侧对中床身",
                                    description:  "气囊压力及侧辊表面状况，侧辊表面无粘铝(<0.05Mpa)",
                                    category:     41,
                                    point_code:   "SC-14100-MRSS01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口传动侧对中床身",
                                    description:  "立辊表面状况，立辊表面无粘铝",
                                    category:     41,
                                    point_code:   "SC-14100-MRSV01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口传动侧对中油缸",
                                    description:  "头部和尾部油缸耳销是否松动。",
                                    category:     41,
                                    point_code:   "SC-14000-MHYZ35",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset15 = Asset.create({
                           serialnum: "1916201015",
                           barcode: "1916201015",
                           name: "入口卷取",
                           description: "入口卷取" })
asset15.check_points.create([
                                {
                                    name:         "入口卷取涨轴",
                                    description:  "表面状况，无卡铝、螺丝无松动",
                                    category:     41,
                                    point_code:   "SC-17200-MENZ01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口卷取装置减速箱",
                                    description:  "各润滑点滴油状况，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-17300-LLZZ03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口卷取装置助卷器",
                                    description:  "钢带有无破损。",
                                    category:     41,
                                    point_code:   "SC-17400-MEWZ01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset16 = Asset.create({
                           serialnum: "1916201016",
                           barcode: "1916201016",
                           name: "入口液压剪液压站",
                           description: "入口液压剪液压站" })
asset16.check_points.create([
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-13100-EETU01",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["150", "", "", "165"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-13100-MEXZ05",
                                    measure_unit: "C",
                                    state:        "",
                                    default_assigned_id: user14.id,
                                    choice:       '["", "", "", "55"]',
                                    frequency:    24
                                },
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-13100-MEXZ05",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-13120-MPHR01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-13130-MPHR02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "入口液压剪液压站",
                                    description:  "3＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-13140-MPHR03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset17 = Asset.create({
                           serialnum: "1916201017",
                           barcode: "1916201017",
                           name: "推床系统液压站",
                           description: "推床系统液压站" })
asset17.check_points.create([
                                {
                                    name:         "推床系统液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-1I200-EETU04",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["150", "", "", "165"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "推床系统液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-1I200-MEXZ09",
                                    measure_unit: "C",
                                    state:        "",
                                    choice:       '["", "", "", "55"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "推床系统液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-1I200-MEXZ09",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "推床系统液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I220-MPHR10",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "推床系统液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I230-MPHR11",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "推床系统液压站",
                                    description:  "3＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I240-MPHR12",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset18 = Asset.create({
                           serialnum: "1916201018",
                           barcode: "1916201018",
                           name: "弯辊系统液压站",
                           description: "弯辊系统液压站" })
asset18.check_points.create([
                                {
                                    name:         "弯辊系统液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-1I300-EETU05",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["200", "", "", "210"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "弯辊系统液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-1I300-MEXZ10",
                                    measure_unit: "C",
                                    state:        "",
                                    choice:       '["", "", "", "55"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "弯辊系统液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-1I300-MEXZ10",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "弯辊系统液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I320-MPHR13",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "弯辊系统液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I330-MPHR14",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                               } ])

asset19 = Asset.create({
                           serialnum: "1916201019",
                           barcode: "1916201019",
                           name: "压上系统液压站",
                           description: "压上系统液压站" })
asset19.check_points.create([
                                {
                                    name:         "压上系统液压站",
                                    description:  "系统压力",
                                    category:     50,
                                    point_code:   "SC-1I400-EETU06",
                                    measure_unit: "Bar",
                                    state:        "",
                                    choice:       '["185", "", "", "210"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压上系统液压站",
                                    description:  "油箱油温",
                                    category:     50,
                                    point_code:   "SC-1I400-MEXZ11",
                                    measure_unit: "C",
                                    state:        "",
                                    choice:       '["", "", "", "55"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压上系统液压站",
                                    description:  "液位，油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-1I400-MEXZ11",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压上系统液压站",
                                    description:  "1＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I420-MPHR15",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压上系统液压站",
                                    description:  "2＃供油泵是否有异响",
                                    category:     41,
                                    point_code:   "SC-1I430-MPHR16",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user14.id,
                                    frequency:    24
                                } ])

asset20 = Asset.create({
                           serialnum: "1916201020",
                           barcode: "1916201020",
                           name: "压下装置",
                           description: "压下装置" })
asset20.check_points.create([
                                {
                                    name:         "压下装置，传动侧减速箱各润滑点滴油状况",
                                    description:  "液面在观察窗的一半位置",
                                    category:     41,
                                    point_code:   "SC-11900-MDEZ02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压下装置，操作侧减速箱各润滑点滴油状况",
                                    description:  "液面在观察窗的一半位置",
                                    category:     41,
                                    point_code:   "SC-11900-MDEZ03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压下装置，传动侧蜗轮蜗杆箱体各润滑点滴油状况",
                                    description:  "液面在观察窗的一半位置",
                                    category:     41,
                                    point_code:   "SC-11900-MDTZ02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "压下装置，操作侧蜗轮蜗杆箱体各润滑点滴油状况",
                                    description:  "液面在观察窗的一半位置",
                                    category:     41,
                                    point_code:   "SC-11900-MEXZ03",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset21 = Asset.create({
                           serialnum: "1916201021",
                           barcode: "1916201021",
                           name: "轧辊冷却系统",
                           description: "轧辊冷却系统" })
asset21.check_points.create([
                                {
                                    name:         "轧辊冷却系统",
                                    description:  "1#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC05",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "轧辊冷却系统",
                                    description:  "2#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC06",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "轧辊冷却系统",
                                    description:  "3#泵是否漏液及振动",
                                    category:     41,
                                    point_code:   "SC-1J300-MPIC07",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset22 = Asset.create({
                           serialnum: "1916201022",
                           barcode: "1916201022",
                           name: "支撑辊轴承座",
                           description: "支撑辊轴承座" })
asset22.check_points.create([
                                {
                                    name:         "支撑辊轴承座",
                                    description:  "润滑管无漏油漏气,管子无破损",
                                    category:     41,
                                    point_code:   "SC-11B10-LLZZ01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])

asset23 = Asset.create({
                           serialnum: "1916201023",
                           barcode: "1916201023",
                           name: "主轧机减速箱",
                           description: "主轧机减速箱" })
asset23.check_points.create([
                                {
                                    name:         "主轧机减速箱，各润滑点滴油状况",
                                    description:  "液面在观察窗的一半位置",
                                    category:     41,
                                    point_code:   "SC-11400-EETS01",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "主轧机减速箱润滑系统",
                                    description:  "开机时油箱油位在油标上下限范围内",
                                    category:     41,
                                    point_code:   "SC-11410-MEXZ02",
                                    state:        "",
                                    choice:       '["正常","异常"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                },
                                {
                                    name:         "主轧机减速箱润滑系统",
                                    description:  "压力",
                                    category:     50,
                                    point_code:   "SC-11410-ZZZZ01",
                                    state:        "",
                                    choice:       '["0.30", "", "", "0.50"]',
                                    default_assigned_id: user13.id,
                                    frequency:    24
                                } ])



route001 = area1.check_routes.create!(
    {name: "热轧线2设备点巡检", description: "热轧线2设备点巡检－机械点检"})
route001.check_points << asset01.check_points
route001.check_points << asset02.check_points
route001.check_points << asset03.check_points
route001.check_points << asset04.check_points
route001.check_points << asset05.check_points
route001.check_points << asset06.check_points
route001.check_points << asset07.check_points
route001.check_points << asset08.check_points
route001.check_points << asset09.check_points
route001.check_points << asset10.check_points
route001.check_points << asset11.check_points
route001.check_points << asset12.check_points
route001.check_points << asset13.check_points
route001.check_points << asset14.check_points
route001.check_points << asset15.check_points
route001.check_points << asset16.check_points
route001.check_points << asset17.check_points
route001.check_points << asset18.check_points
route001.check_points << asset19.check_points
route001.check_points << asset20.check_points
route001.check_points << asset21.check_points
route001.check_points << asset22.check_points
route001.check_points << asset23.check_points


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
user1.preferred_points <<  asset08.check_points
user3.preferred_points <<  asset08.check_points
user1.preferred_points <<  asset09.check_points
user3.preferred_points <<  asset09.check_points
user1.preferred_points <<  asset10.check_points
user3.preferred_points <<  asset10.check_points
user1.preferred_points <<  asset11.check_points
user3.preferred_points <<  asset11.check_points
user1.preferred_points <<  asset12.check_points
user3.preferred_points <<  asset12.check_points
user1.preferred_points <<  asset13.check_points
user3.preferred_points <<  asset13.check_points
user1.preferred_points <<  asset14.check_points
user3.preferred_points <<  asset14.check_points
user1.preferred_points <<  asset15.check_points
user3.preferred_points <<  asset15.check_points
user1.preferred_points <<  asset16.check_points
user3.preferred_points <<  asset16.check_points
user1.preferred_points <<  asset17.check_points
user3.preferred_points <<  asset17.check_points
user1.preferred_points <<  asset18.check_points
user3.preferred_points <<  asset18.check_points
user1.preferred_points <<  asset19.check_points
user3.preferred_points <<  asset19.check_points
user1.preferred_points <<  asset20.check_points
user3.preferred_points <<  asset20.check_points
user1.preferred_points <<  asset21.check_points
user3.preferred_points <<  asset21.check_points

route001.users << user1
route001.users << user3






