module AssetsHelper
  include ApplicationHelper
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['points'] =  result.check_points.map {   |point|
                            point.id
                          }
      results << entry
    end

    results
  end
end

