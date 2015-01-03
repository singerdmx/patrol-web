module ProblemListHelper
  include ApplicationHelper

  def index_json_builder(index_result)
    index_result.map do |result|
      db_result_to_hash(result)
    end
  end

  def db_result_to_hash(result)
    entry = to_hash(result)

    entry['status'] = 0 if entry['status'].nil?

    entry['created_at'] = entry['created_at'].to_i
    entry['updated_at'] = entry['updated_at'].to_i
    entry['plan_date'] = entry['plan_date'].to_time.to_i if entry['plan_date']

    asset = Asset.find(entry['asset_id'])
    barcode = asset.barcode
    case entry['kind']
      when 'POINT'
        point = CheckPoint.find(entry['check_point_id'])
        entry['name'] = "#{asset.name} #{point.name}"
        barcode = point.barcode
        entry['point_description'] = point.description
      when 'ASSET'
        entry['name'] = asset.name
        entry['point_description'] = ''
      else
        fail "Invalid kind '#{kind}'!"
    end

    entry['barcode'] = barcode.nil? ? '' : barcode

    created_by_user = User.find_by(id: entry['created_by_id'])
    entry['created_by_user'] = created_by_user.nil? ? '' : created_by_user.name

    assigned_to_user = User.find_by(id: entry['assigned_to_id'])
    entry['assigned_to_user'] = assigned_to_user.nil? ? '' : assigned_to_user.name

    entry
  end

  def index_ui_json_builder(index_result)
    index_result.map do |r|
      [
        r['created_at'],
        r['created_by_user'],
        r['name'],
        r['point_description'],
        r['description'],
        r['assigned_to_user'],
        get_problem_status_string(r['status'].to_i),
        r['content'],
        r['plan_date'],
        r['id']
      ]
    end
  end
end
