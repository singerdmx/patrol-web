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

  def to_hash(record)
    hash = {}
    record.attributes.each do |k,v|
      hash[k] = v unless k.in? HASH_EXCLUSION
    end

    hash
  end
end
