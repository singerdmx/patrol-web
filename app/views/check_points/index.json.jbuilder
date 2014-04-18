json.array! @check_points do |point|
  json.id point.id
  json.description point.description
  json.name point.name
  json.state point.state
  json.choice point.choice
  json.category point.category
  json.barcode point.barcode

  json.routes point.check_routes.map {   |route|
    route.id
  }
  json.asset point.asset.id
end

