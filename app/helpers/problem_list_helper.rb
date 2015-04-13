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
    entry['area'] = ''
    case entry['kind']
      when 'POINT'
        process_point_or_part(asset, CheckPoint.find(entry['check_point_id']), entry)
      when 'PART'
        process_point_or_part(asset, Part.find(entry['part_id']), entry)
      when 'ASSET'
        entry['name'] = asset.name
        entry['point_description'] = ''
      else
        fail "Invalid kind '#{kind}'!"
    end

    entry['barcode'] = barcode || ''

    created_by_user = User.find_by(id: entry['created_by_id'])
    entry['created_by_user'] = created_by_user.nil? ? '' : created_by_user.name

    assigned_to_user = User.find_by(id: entry['assigned_to_id'])
    entry['assigned_to_user'] = assigned_to_user.nil? ? '' : assigned_to_user.name
    entry['image'] = ResultImage.find(entry['result_image_id']).url if entry['result_image_id']
    entry['audio'] = ResultAudio.find(entry['result_audio_id']).url if entry['result_audio_id']
    entry['result'] = ''
    if result.check_result_id
      check_result = CheckResult.find(result.check_result_id)
      entry['session'] = check_result.check_session_id
      entry['result'] = check_result.result
    end

    entry
  end

  def problem_list_ui_json_builder(index_result)
    index_result.map do |r|
      if r['kind'] == 'POINT'
        point = CheckPoint.find(r['check_point_id'])
        r['point'] = to_hash(point)
      end

      [
        r['created_at'],
        r['created_by_user'],
        r['area'],
        r['result'],
        get_point_normal_range(r),
        r['name'],
        r['point_description'],
        r['description'],
        r['assigned_to_user'],
        get_problem_status_string(r['status'].to_i),
        r['content'],
        r['plan_date'],
        r['id'],
        r['session'],
        [r['image'], r['audio']]
      ]
    end
  end

  private

  def process_point_or_part(asset, p, entry)
    entry['name'] = "#{asset.name} #{p.name}"
    barcode = p.barcode
    entry['point_description'] = p.description
    if entry['area_id']
      areas = Area.where(id: entry['area_id'])
      entry['area'] = areas.first.name unless areas.empty?
    end
  end

  def set_report_num(report)
    report_num = report.created_at.strftime('%Y%m%d') + report.id.to_s.rjust(4, '0')
    Rails.logger.info("set report_num #{report_num}")
    report.update_attributes(report_num: report_num)
  end
end
