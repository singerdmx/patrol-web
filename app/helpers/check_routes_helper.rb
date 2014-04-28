module CheckRoutesHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(check_routes, route_assets)
    results = []
    check_routes.each do |route|
      entry = to_hash(route)

      entry.delete_if {|key, value| key.in?(['created_at', 'updated_at']) }

      if route_assets.nil?
        entry['points'] =  route.check_points.map {   |point|
          point.id
        }
      else
        entry['assets'] = []
        route_assets[route.id].keys.each do |key|
          entry['assets'] <<
            {
              'id'=> key,
              'points' => route_assets[route.id][key].to_a
            }

        end
      end
      results << entry
    end

    results
  end
end

