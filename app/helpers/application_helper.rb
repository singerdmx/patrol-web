module ApplicationHelper

  HASH_EXCLUSION = ['created_at', 'updated_at']

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    if page_title.empty?
      '移动巡检报修'
    else
      page_title
    end
  end

  def to_hash(record, exclusion = false, to_sym = false)
    hash = {}
    record.attributes.each do |k,v|
      next if k == 'tombstone'
      k = k.to_sym if to_sym
      hash[k] = v unless exclusion and k.in? HASH_EXCLUSION
    end

    hash
  end

  def to_excel(record, keys_to_delete = [])
    r = {}
    record.attributes.each do |k,v|
      next if keys_to_delete.include?(k.to_sym)

      v = '是' if v == true
      v = '否' if v == false
      r[k.to_sym] = v
    end

    r[:check_point_id] = CheckPoint.find(r[:check_point_id]).name if r[:check_point_id]
    r[:part_id] = Part.find(r[:part_id]).name if r[:part_id]
    r[:area_id] = Area.find(r[:area_id]).name if r[:area_id]
    r[:result_image_id] = ResultImage.find(r[:result_image_id]).url if r[:result_image_id]
    r[:result_audio_id] = ResultAudio.find(r[:result_audio_id]).url if r[:result_audio_id]
    r[:created_by_id] = User.find(r[:created_by_id]).name if r[:created_by_id]
    r[:assigned_to_id] = User.find(r[:assigned_to_id]).name if r[:assigned_to_id]
    r[:asset_id] = Asset.find(r[:asset_id]).name if r[:asset_id]
    [:created_at, :updated_at, :check_time, :plan_date].each do |time_key|
      r[time_key] = r[time_key].strftime("%Y年%m月%d日 %H:%M") if r[time_key]
    end

    r
  end

  def update_excel_titles(records, additional_mapping = {})
    mapping = {
      id: 'ID',
      created_at: '创建时间',
      updated_at: '更新时间',
      area_id: '机台信息',
      result_image_id: '图片',
      result_audio_id: '音频',
      check_session_id: '任务编号',
      part_id: '部件',
      check_point_id: '检点',
      asset_id: '设备',
      check_time: '巡检时间',
      memo: '备注',
      result: '读数',
      status: '状态',
      report_num: '工单号',
      created_by_id: '提交人',
      assigned_to_id: '责任人',
      plan_date: '计划完成日期',
      priority: '优先级',
      description: '描述',
      check_result_id: '巡检记录编码'
    }

    records.map do |r|
      mapping.merge(additional_mapping).each do |k, v|
        next unless r.has_key?(k)

        r[v.to_sym] = r[k]
        r.delete(k)
      end

      r
    end
  end

  def show_full_view?
    current_user.is_admin? || current_user.is_leader?
  end

  def get_category_string(category)
    case category
      when 10 then '巡更'
      when 20 then '润滑'
      when 30 then '抄表'
      when 40 then '状态'
      when 41 then '普通巡检'
      when 50 then '日常巡检'
      else "#{category}"
    end
  end

  def get_problem_status_string(status)
    case status
      when 0 then '全部'
      when 1 then '完成'
      when 2 then '未完成'
      when 3 then '取消'
      when 4 then '进行中'
      when 5 then '部分完成'
      else "#{status}"
    end
  end

  def get_point_normal_range(result)
    return '' unless result['point']
    # try 标准值 first

    standard = result['point']['standard']
    return standard if standard && !standard.empty?
      return standard

    choice = JSON.parse(result['point']['choice'])

    case result['point']['category']
      when 50
        if choice[0] != '' and choice[3] != ''
          "#{choice[0]} - #{choice[3]} #{result['point']['measure_unit']}"
        elsif choice[0] != ''
          "大于#{choice[0]} #{result['point']['measure_unit']}"
        elsif choice[3] != ''
          "小于#{choice[3]} #{result['point']['measure_unit']}"
        else
          'N/A'
        end
      else ''
    end
  end
end
