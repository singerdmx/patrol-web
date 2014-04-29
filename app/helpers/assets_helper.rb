module AssetsHelper
  include ApplicationHelper
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['points'] =  result.check_points.map {   |point|
                            point.id
                          }
      entry.delete_if {|key, value| key.in?(['created_at', 'updated_at']) }
      results << entry
    end

    results
  end
end

