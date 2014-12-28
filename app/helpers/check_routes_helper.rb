require_relative '../../app/config/settings'

module CheckRoutesHelper
  include ApplicationHelper
  include Config

  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(check_routes, route_assets, show_name = false)
    check_routes.map do |route|
      entry = to_hash(route)
      if route_assets.nil?
        entry['points'] = route.check_points.map do |point|
          if show_name
            point.name
          else
            point.id
          end
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
      entry['area_name'] = Area.find(route.area_id).name if show_name
      if show_name
        if entry['contacts']
          contacts = JSON.parse(entry['contacts'])
          entry['contacts'] = contacts.map do |id|
            c = Contact.find(id)
            "#{c.email} (#{c.name})"
          end
        end
      else
        entry.except!('contacts')
      end
      entry
    end
  end

  # route_assets: Key is route id and value is assets (Hash of key = asset id and value = points)
  # route_map: Key is route id and value is route
  # asset_map: Key is asset id and value is asset
  def index_ui_json_builder(route_assets, route_map, asset_map)
    fail "route_assets is nil! Please set 'group_by_asset' to 'true'." if route_assets.nil?
    route_assets.map do |route_id, assets|
      route = {}
      route[:id] = route_id
      route[:kind] = 'route'
      route[:icon] = assets.empty? ? 'blank.png' : 'minus.png'
      route[:title] = '路线'
      route[:description] = route_map[route_id].name
      route[:children] = route_assets_children(assets, asset_map)
      route
    end
  end

  private

  def route_assets_children(assets, asset_map)
    children = []
    preference_points = Set.new
    current_user.preferred_points.each do |p|
      preference_points.add(p.id)
    end
    assets.each do |asset_id, points|
      asset = {}
      if points.size == 1 and Settings::CATEGORY_SCAN_ONLY.include? points.first.category
        # dummy asset
        point = points.first
        asset[:id] = point.id
        asset[:kind] = 'point'
        asset[:icon] = preference_points.include?(point.id) ? 'care.png' : 'tool.png'
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
          {
            id: point.id,
            kind: 'point',
            icon: preference_points.include?(point.id) ? 'care.png' : 'tool.png',
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

  def get_routes(check_route_params)
    if user_signed_in? && current_user.is_user?
      current_user.check_routes.where(check_route_params)
    else
      CheckRoute.where(check_route_params)
    end
  end

end

