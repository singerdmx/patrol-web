# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
asset = Asset.create({tag:'abc', number: 123})
asset.check_points.create([{site_id: 111},{site_id:222}])
route = CheckRoute.create!({description:'路线一'})
route.assets<< asset


asset2 = Asset.create({tag:'def', number: 456})
route.assets<< asset2
CheckRoute.create!({description:'路线2'})

