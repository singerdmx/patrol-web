
if  @route_assets.nil?
    json.array! @check_routes do |route|
      json.id route.id
      json.description route.description
      json.points route.check_points.map {   |point|
        point.id
      }
    end
else
    json.array! @check_routes do |route|
      json.id route.id
      json.description route.description
      json.assets @route_assets[route.id].keys.each do |key|
            json.id key
            json.points @route_assets[route.id][key].to_a
      end
    end
end