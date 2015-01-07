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

  def to_hash(record, exclusion = false)
    hash = {}
    record.attributes.each do |k,v|
      hash[k] = v unless exclusion and k.in? HASH_EXCLUSION
    end

    hash
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
      when 2 then '部分完成'
      when 3 then '取消'
      when 4 then '进行中'
      when 5 then '未开始'
      else "#{status}"
    end
  end
end
