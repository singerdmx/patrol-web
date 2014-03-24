json.array! @check_routes do |route|
  json.id route.id
  json.description route.description
  json.assets route.assets.map {   |asset|
    asset.id
  }
end