module ApplicationHelper

  HASH_EXCLUSION = ['created_at', 'updated_at']

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "巡检"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
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
end
