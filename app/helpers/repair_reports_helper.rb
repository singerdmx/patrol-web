module RepairReportsHelper
  include ApplicationHelper

  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      case entry['status']
        when nil, 0
          entry['status'] = "新建"
        when 1
          entry['status'] = "进行中"
        when 2
          entry['status'] = "完成"
        else
          entry['status'] = "暂停"
      end

      ticket_name = ""
      asset = Asset.find_by(id: entry['asset_id'])
      ticket_name = asset.name if asset
      if entry['kind'] == "POINT"
        point = CheckPoint.find_by(id: entry['check_point_id'])
        ticket_name = "#{ticket_name} #{point.name}" if point
      end
      entry['name'] = ticket_name

      entry['created_by_user'] = ""
      created_by_user = User.find_by(id: entry['created_by_id'])
      entry['created_by_user'] = created_by_user.name if created_by_user

      entry['assigned_to_user'] = ""
      assigned_to_user = User.find_by(id: entry['assigned_to_id'])
      entry['assigned_to_user'] = assigned_to_user.name if assigned_to_user

      entry
    end
  end
end
