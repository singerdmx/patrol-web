json.array! @assets do |asset|
  json.id asset.id
  json.number asset.number
  json.parent asset.parent
  json.serialnum asset.serialnum
  json.tag asset.tag
  json.location asset.location
  json.description asset.description
  json.vendor asset.vendor
  json.failure_code asset.failure_code
  json.manufacture asset.manufacture
  json.purchase_pri asset.purchase_pri
  json.replace_cost asset.replace_cost
  json.install_date asset.install_date
  json.warranty_expire asset.warranty_expire
  json.total_cost asset.total_cost
  json.ytd_cost asset.ytd_cost
  json.budget_cost asset.budget_cost
  json.calnum asset.calnum
  json.routes asset.check_routes.map {   |route|
      route.id
    }
  json.points asset.check_points.map {   |point|
      point.id
    }
end