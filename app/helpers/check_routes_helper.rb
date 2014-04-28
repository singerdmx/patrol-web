require_relative '../../app/config/settings'

module CheckRoutesHelper
  include ApplicationHelper
  include Config

  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(check_routes, route_assets)
    results = []
    check_routes.each do |route|
      entry = to_hash(route)

      entry.delete_if {|key, value| key.in?(['created_at', 'updated_at']) }

      if route_assets.nil?
        entry['points'] = route.check_points.map do |point|
          point.id
        end
      else
        entry['assets'] = []
        route_assets[route.id].keys.each do |key|
          entry['assets'] <<
            {
              'id'=> key,
              'points' => route_assets[route.id][key].map { |p| p.id }
            }
        end
      end
      results << entry
    end

    results
  end

  # route_assets: Key is route id and value is assets (Hash of key = asset id and value = points)
  # route_map: Key is route id and value is route
  # asset_map: Key is asset id and value is asset
  def index_ui_json_builder(route_assets, route_map, asset_map)
    fail "route_assets is nil! Please set 'group_by_asset' to 'true'." if route_assets.nil?
    results = []
    route_assets.each do |route_id, assets|
      route = {}
      route[:id] = route_id
      route[:kind] = 'route'
      route[:icon] = assets.empty? ? 'blank.png' : 'minus.png'
      route[:title] = '路线'
      route[:description] = route_map[route_id].name
      route[:children] = route_assets_children(assets, asset_map)
      results << route
    end

    results
  end

  private

  def route_assets_children(assets, asset_map)
    children = []
    assets.each do |asset_id, points|
      asset = {}
      if points.size == 1 and Settings::CATEGORY_SCAN_ONLY.include? points.first.category
        # dummy asset
        point = points.first
        asset[:id] = point.id
        asset[:kind] = 'point'
        asset[:icon] = 'tool.png'
        asset[:title] = point.name
        asset[:description] = point.description
        asset[:children] = []
      else
        asset[:id] = asset_id
        asset[:kind] = 'asset'
        asset[:icon] = points.empty? ? 'blank.png' : 'minus.png'
        asset[:title] = '设备'
        asset[:description] = asset_map[asset_id].name
        asset[:children] = points.map do |point|
          next if Settings::CATEGORY_SCAN_ONLY.include? point.category
          {
            id: point.id,
            kind: 'point',
            icon: 'tool.png',
            title: point.name,
            description: point.description,
            children: []
          }
        end
      end

      children << asset
    end
    children
  end

end

