module RepairReportsHelper
  include ApplicationHelper

  def index_json_builder(index_result)
    index_result.map do |result|
      entry = to_hash(result)
      case entry['status']
        when nil, 0
          entry['status'] = "新建"
        when 1
          entry['status'] = "进行"
        when 2
          entry['status'] = "完成"
        else
          entry['status'] = "暂停"
      end
      entry
    end
  end
end
