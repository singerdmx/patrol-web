module CheckResultsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    results = []
    index_result.each {|result|
      entry = to_hash(result)
      entry["point"] = result.check_point
      entry["session"] = result.check_session
      entry.delete_if {|key, value| key.in?(['check_point_id', 'check_session_id', 'created_at', 'updated_at']) }
      results << entry
    }
    results

  end

end
