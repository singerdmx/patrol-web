module ManualsHelper
  include ApplicationHelper

  def index_json_builder(db_results)
    db_results.map do |result|
      to_hash(result, true)
    end
  end

  def index_ui_json_builder(db_results)
    db_results.map do |result|
      entry = to_hash(result, true)
      assets = Asset.where(manual_id: entry['id']).where(tombstone: false)
                 .map {|a| "#{a.name} #{a.description}"}
      [
        entry['id'],
        entry['name'],
        get_manual_ui_entry(assets.length, entry['entry']),
        assets
      ]
    end
  end

  def get_manual_ui_entry(asset_num, entry)
    content = ''
    line = 0
    count = 0
    max_line_length = 30
    max_lines = [3, asset_num].max
    entry.length.times.each do |i|
      break if line >= max_lines
      c = entry[i]
      if c.match(/^\n$/)
        content += '<br/>'
        count = 0
        line += 1
      else
        content += c
        count += 1
      end

      if count == max_line_length
        content += '<br/>'
        count = 0
        line += 1
      end
    end
    content
  end
end
