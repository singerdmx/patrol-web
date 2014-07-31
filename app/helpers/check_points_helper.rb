require 'json'

module CheckPointsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['asset'] = result.asset.id
      entry['routes'] = result.check_routes.map do |route|
        route.id
      end
      results << entry
    end

    results
  end

  def index_ui_json_builder(index_result)
    results = []
    index_result.each do |result|
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
      results << [
        entry['id'],
        entry['name'],
        entry['barcode'],
        get_category_string(entry['category']),
        choice,
        result.asset.name,
        result.check_routes.map do |route|
          route.name
        end
      ]
    end

    results
  end
end

