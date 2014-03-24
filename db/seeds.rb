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

route_descriptions.each do |route_des|
  route = CheckRoute.create!({description:route_des})
  asset = Asset.create({tag: SecureRandom.urlsafe_base64(10), number: SecureRandom.random_number(5), serialnum: SecureRandom.urlsafe_base64(10)})
  asset.check_points.create([{site_id: SecureRandom.random_number(5)},{site_id:SecureRandom.random_number(5)}])
  route.assets<< asset


  asset = Asset.create({tag: SecureRandom.urlsafe_base64(10), number: SecureRandom.random_number(5), serialnum: SecureRandom.urlsafe_base64(10)})
  asset.check_points.create([{site_id: SecureRandom.random_number(5)},{site_id:SecureRandom.random_number(5)}])
  route.assets<< asset
end


