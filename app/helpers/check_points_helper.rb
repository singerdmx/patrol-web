module CheckPointsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry['routes'] = result.check_routes.map {   |route|
                route.id
              }
      results << entry
    end

    results
  end
end

