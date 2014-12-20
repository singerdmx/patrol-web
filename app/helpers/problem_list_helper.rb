module ProblemListHelper
  include ApplicationHelper

  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)

      entry['status'] = 0 if entry['status'].nil?

      entry['created_at'] = entry['created_at'].to_i
      entry['updated_at'] = entry['updated_at'].to_i

      asset = Asset.find_by(id: entry['asset_id'])
      ticket_name = asset.name if asset
      barcode = asset.barcode if asset
      if entry['kind'] == "POINT"
        point = CheckPoint.find_by(id: entry['check_point_id'])
        ticket_name = "#{ticket_name} #{point.name}" if point
        barcode = point.barcode if point
      end
      entry['name'] = ticket_name.nil? ? "" : ticket_name
      entry['barcode'] = barcode.nil? ? "" : barcode

      created_by_user = User.find_by(id: entry['created_by_id'])
      entry['created_by_user'] = created_by_user.nil? ? "" : created_by_user.name

      assigned_to_user = User.find_by(id: entry['assigned_to_id'])
      entry['assigned_to_user'] = assigned_to_user.nil? ? "" : assigned_to_user.name

      entry
    end
  end
end
