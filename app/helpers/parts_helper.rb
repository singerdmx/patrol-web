module PartsHelper
  include ApplicationHelper

  def index_json_builder(db_results)
    db_results.map do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry
    end
  end

  def index_ui_json_builder(db_results)
    db_results.map do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry['barcode'] = '无' if entry['barcode'].nil?
      [
        entry['id'],
        entry['name'],
        entry['barcode'],
        result.asset.name,
        entry['default_assigned_id'].nil? ? '' : User.find(entry['default_assigned_id']).name
      ]
    end
  end
end
