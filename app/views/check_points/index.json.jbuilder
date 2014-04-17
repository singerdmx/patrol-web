json.array! @check_points do |point|
  json.id point.id
  json.description point.description
  json.name point.name
  json.status point.status
  json.choice point.choice
  json.type point.type
  json.barcode point.barcode

  json.routes point.check_routes.map {   |route|
    route.id
  }
  json.asset point.asset.id
end

