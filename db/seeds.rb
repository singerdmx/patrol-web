# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'securerandom'

#route 1
route_descriptions = ['一工区机械8小时点巡检', '二工区机械8小时点巡检','三工区机械8小时点巡检', '四工区机械8小时点巡检' ]
asset_descriptions = ['轧机电机','轧机联轴器','轧机减速机']
point_descriptions = ['轴承','箱体','安全销','输入端轴承','输出端轴承']
tpm_types = ['震动','温度','声音','断裂']
asset_status = ['运转','停止']
point_standard = ['<=70', '安静']
route_descriptions.each do |route_des|
  route = CheckRoute.create!({description:route_des})
  asset = Asset.create({tag: SecureRandom.urlsafe_base64(10), barcode:SecureRandom.uuid, number: SecureRandom.random_number(5), serialnum: SecureRandom.urlsafe_base64(10), description:asset_descriptions.sample })
  asset.check_points.create([{site_id: SecureRandom.random_number(500), description:point_descriptions.sample,  cstm_tpmid: SecureRandom.random_number(300), tpm_type:tpm_types.sample, period: 1, period_unit: 'D', status: asset_status.sample, standard: point_standard.sample },{site_id:SecureRandom.random_number(500), description:point_descriptions.sample,  cstm_tpmid: SecureRandom.random_number(300), tpm_type:tpm_types.sample, period: 1, period_unit: 'D', status: asset_status.sample, standard: point_standard.sample}])
  route.assets<< asset


  asset = Asset.create({tag: SecureRandom.urlsafe_base64(10), barcode:SecureRandom.uuid, number: SecureRandom.random_number(5), serialnum: SecureRandom.urlsafe_base64(10), description:asset_descriptions.sample})
  asset.check_points.create([{site_id: SecureRandom.random_number(500), description:point_descriptions.sample,  cstm_tpmid: SecureRandom.random_number(300), tpm_type:tpm_types.sample, period: 1, period_unit: 'D', status: asset_status.sample, standard: point_standard.sample},{site_id:SecureRandom.random_number(500), description:point_descriptions.sample,  cstm_tpmid: SecureRandom.random_number(300), tpm_type:tpm_types.sample, period: 1, period_unit: 'D', status: asset_status.sample, standard: point_standard.sample}])
  route.assets<< asset
end
CheckResult.create({result: 'pass', check_route_id:1,  check_point_id: 2, session: 34})
CheckResult.create({result: 'fail', check_route_id:1,  check_point_id: 3, session: 34})
CheckResult.create({result: 'pass', check_route_id:2,  check_point_id: 1, session: 444})
CheckResult.create({result: 'fail', check_route_id:2,  check_point_id: 2, session: 444})



