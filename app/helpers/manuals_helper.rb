module ManualsHelper
  include ApplicationHelper

  def index_json_builder(db_results)
    db_results.map do |result|
      to_hash(result, true)
    end
  end

  def index_ui_json_builder(db_results)
    db_results.map do |result|
      entry = to_hash(result, true)
      assets = Asset.where(manual_id: entry['id']).where(tombstone: false)
                 .map {|a| "#{a.name} #{a.description}"}
      [
        entry['id'],
        entry['name'],
        entry['entry'],
        assets
      ]
    end
  end
end
