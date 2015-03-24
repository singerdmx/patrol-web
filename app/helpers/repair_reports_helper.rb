module RepairReportsHelper
  include ApplicationHelper

  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)

      entry['status'] = 5 if entry['status'].nil?

      entry['created_at'] = entry['created_at'].to_i
      entry['updated_at'] = entry['updated_at'].to_i

      asset = Asset.find_by(id: entry['asset_id'])
      ticket_name = asset.name if asset
      barcode = asset.barcode if asset
      if entry['kind'] == "POINT"
        point = CheckPoint.find_by(id: entry['check_point_id'])
        if point
          ticket_name = "#{ticket_name} #{point.name}"
          barcode = point.barcode
        end
      elsif entry['kind'] == "PART"
        part = Part.find_by(id: entry['part_id'])
        if part
          ticket_name = "#{ticket_name} #{part.name}"
          barcode = part.barcode if part
        end
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

  def index_json_chart_builder(reports, part_id, date_range)
    results = {}
    results['part'] = to_hash(Part.find(part_id))
    results['result'] = []

    error_ranges = []
    reports.each do |r|
      case get_problem_status_string(r.status)
        when '完成', '取消'
          error_ranges << [r.created_at, r.updated_at]
        else
          error_ranges << [r.created_at, Time.now]
      end
    end
    status = 0
    hit_error_end = false
    error_range_index = 0
    # map converts date_range to one day interval
    # ignore last tick since it is extra
    date_range = date_range.map { |t| t }[0..-2]
    results['result'] = date_range.map do |t|
      if hit_error_end
        error_range_index += 1
        status = 0
        hit_error_end = false
      end

      error_range = error_ranges[error_range_index]
      if status > 0
        # see if hit error end
        error_end = error_range[1]
        if t <= error_end and error_end <= t + 24.hours
          hit_error_end = true
        end
      else
        while error_range
          # see if hit error beg
          error_beg = error_range[0]
          break if error_beg > t + 24.hours
          error_end = error_range[1]
          if error_beg <= t + 24.hours and t <= error_end
            status = 1
            break
          end
          error_range_index += 1
          error_range = error_ranges[error_range_index]
        end
      end

      {
        time: t.to_i,
        status: status
      }
    end
    results
  end

  private

end
