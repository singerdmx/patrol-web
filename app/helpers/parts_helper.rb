module PartsHelper
  include ApplicationHelper

  def index_json_builder(db_results)
    db_results.map do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry
    end
  end
end
