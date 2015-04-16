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

  def to_excel(records, keys)
    records.map do |r|
      record = {}
      r.each_with_index do |v, i|
        key = keys[i]
        next if key.nil?
        if [:created_at, :updated_at, :check_time].include?(key)
          v = Time.at(v).to_datetime.strftime("%Y年%m月%d日 %H:%M") if v
        elsif [:plan_date].include?(key)
          v = Time.at(v).to_datetime.strftime("%Y年%m月%d日") if v
        end
        record[key] = v
      end
      record
    end
  end

  def update_excel_titles(records, additional_mapping = {})
    mapping = {
      name: '名称',
      description: '描述',
      barcode: '条形码',
      standard: '标准值',
      created_at: '日期',
      updated_at: '更新时间',
      area_id: '机台信息',
      result_image_id: '图片',
      result_audio_id: '音频',
      part_name: '部位名称',
      check_point_id: '检点',
      asset_id: '设备',
      check_time: '检测时间',
      memo: '备注',
      result: '读数',
      status: '状态',
      report_num: '工单号',
      created_by_id: '提交人',
      assigned_to_id: '责任人',
      plan_date: '计划完成日期',
      priority: '优先级',
      description: '描述',
      content: '内容',
      problem_description: '问题描述',
      media: '媒体'
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

  def get_point_standard(result)
    return '' unless result['point']

    # try 标准值 first
    standard = result['point']['standard']
    return standard unless standard.blank?

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
