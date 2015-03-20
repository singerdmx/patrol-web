module AssetsHelper
  include ApplicationHelper
  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      entry['points'] =
        result.check_points.map do |point|
          point.id
        end
      entry['parts'] =
        result.parts.map do |part|
          part.id
        end
      entry.delete('manual_id') if entry['manual_id'].nil?
      entry
    end
  end

  def index_ui_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      entry['barcode'] = '无' if entry['barcode'].nil?
      [
        entry['id'],
        entry['name'],
        entry['barcode'],
        result.check_points.map do |point|
          point.name
        end
      ]
    end
  end

  def index_parts_tree_view_json_builder(index_result)
    index_result.map do |result|
      asset = {}
      asset[:id] = result.id
      asset[:kind] = 'asset'
      asset[:title] = '设备'
      asset[:icon] = result.parts.empty? ? 'blank.png' : 'minus.png'
      asset[:description] = result.name
      asset[:children] = result.parts.map do |part|
        {
          id: part.id,
          kind: 'part',
          icon: 'tool.png',
          title: part.name,
          description: part.description,
          children: []
        }
      end
      asset
    end
  end
end

