require 'json'

module CheckResultsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    results = []
    index_result.each do |result|
      entry = to_hash(result)
      entry['point'] = result.check_point
      entry['session'] = result.check_session
      entry.delete_if {|key, value| key.in?(['check_point_id', 'check_session_id', 'created_at', 'updated_at']) }
      results << entry
    end

    results
  end

  def index_ui_json_builder(check_results_json)
    check_results_json.map do |result|
      status = case result['status']
                 when 0 then '正常'
                 when 1 then '异常'
                 when 2 then '警告'
                 else '未知'
               end
      choice = JSON.parse(result['point']['choice'])
      range = case result['point']['category']
                when 50
                  if choice[0] != '' and choice[3] != ''
                    "介于#{choice[0]}和#{choice[3]}之间"
                  elsif choice[0] != ''
                    "大于#{choice[0]}"
                  elsif choice[3] != ''
                    "小于#{choice[3]}"
                  else
                    ''
                  end
                else ''
              end
      [
        result['point']['name'], result['point']['description'],
        result['result'],
        range,
        status,
        result['memo'],
        result['point']['barcode'],
        result['check_time'].to_i * 1000
      ]
    end
  end

  def get_results(check_result_params, preferred = false)
    if user_signed_in?
      if preferred
        points = current_user.preferred_points
      else
        points = current_user.all_points
      end
      points = points.map{|point| point.id}.to_a
      if check_result_params[:check_point_id].nil?
        check_result_params[:check_point_id] = points
      else
        #remember to convert to integer in order to check inclusion against integer array
        return CheckResult.none if !points.include?(check_result_params[:check_point_id].to_i)
      end
    end
    CheckResult.where(check_result_params)

  end

end
