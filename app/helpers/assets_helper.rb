module AssetsHelper
  include ApplicationHelper
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['points'] = result.check_points.map do |point|
        point.id
      end
      results << entry
    end

    results
  end

  def index_ui_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['barcode'] = '无' if entry['barcode'].nil?
      results << [
        entry['id'],
        entry['name'],
        entry['barcode'],
        result.check_points.map do |point|
          point.name
        end
      ]
    end

    results
  end
end

