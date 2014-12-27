require 'json'

module CheckPointsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      entry['state'] = "" if entry['state'].nil?
      entry['default_value'] = '' if entry['default_value'].nil?
      entry['asset'] = result.asset.id
      entry.delete('manual_id') if entry['manual_id'].nil?
      entry['routes'] = result.check_routes.map do |route|
        route.id
      end
      entry
    end
  end

  def index_ui_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry['routes'] = result.check_routes.map do |route|
        route.id
      end

      entry['barcode'] = '无' if entry['barcode'].nil?
      choice = []
      choice = JSON.parse(entry['choice']) unless entry['choice'].nil?
      if entry['category'] == 50
        prefix = ['正常下限', '警戒下限', '警戒上限', '正常上限']
        choice = choice.each_with_index.map do |c, i|
          "#{prefix[i]}： #{(c.nil? or c.empty?) ? '无' : c}"
        end
      end

      [
        entry['id'],
        entry['name'],
        entry['barcode'],
        get_category_string(entry['category']),
        choice,
        result.asset.name,
        result.check_routes.map do |route|
          route.name
        end,
        entry['default_assigned_id'].nil? ? '' : User.find(entry['default_assigned_id']).name
      ]
    end
  end
end

