module AssetsHelper
  include ApplicationHelper, RepairReportsHelper
  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      entry['points'] =
        result.check_points.select{|p| !p.tombstone}.map {|p| p.id}
      entry['parts'] =
        result.parts.select{|p| !p.tombstone}.map {|p| p.id}
      entry.delete('manual_id') if entry['manual_id'].nil?
      entry
    end
  end

  def index_ui_json_builder(index_result, repair)
    index_result.map do |result|
      entry = to_hash(result)
      points_or_parts = repair ? result.parts : result.check_points
      points_or_parts = points_or_parts.select{|p| !p.tombstone}.map { |p| p.name }

      entry['barcode'] = '无' if entry['barcode'].nil?
      [
        entry['id'],
        entry['name'],
        entry['barcode'],
        points_or_parts
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
      asset[:children] = result.parts.select{|p| !p.tombstone}.map do |part|
        {
          id: part.id,
          kind: 'part',
          icon: 'tool.png',
          title: part.name,
          description: part.description.nil? ? '' : part.description,
          status_code: part.status,
          status: get_part_status_string(part.status),
          children: []
        }
      end
      asset
    end
  end
end

