require 'json'

module CheckResultsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result)
    if params[:aggregate].nil?
      results = []
      index_result.each do |entry|
        result = to_hash(entry)
        result['point'] = entry.check_point
        result['session'] = entry.check_session
        result.delete_if {|key, value| key.in?(['check_point_id', 'check_session_id']) }
        results << result
      end
    elsif params[:aggregate].to_i > 0
      results = {}
      group = params[:aggregate].to_i
      results['group'] = false
      results['group'] = true if index_result.size() > group

      if !params[:check_point_id].nil?
        results['point'] = to_hash(CheckPoint.find(check_result_params[:check_point_id]))
      end
      case results['point']['category']
        when 30, 50
          results['result'] = aggregate_numeric_results(index_result, group)
        else
          raise "point category #{results['point']['category']} not supported for aggregated view"
      end
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
                    'N/A'
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
        result['check_time']
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

    CheckResult.where(check_result_params).order(check_time: :asc)
  end

  private

  def aggregate_numeric_results(index_result, group)
    num_per_group =  index_result.count / group
    remainder =  index_result.count % group
    border = remainder * (num_per_group+1)
    aggregated_results = []
    total = counter = 0
    min_val = max_val = min_time = max_time = nil
    index_result.each do |entry|
      result = to_hash(entry)
      result['check_time'] = result['check_time'].to_i
      result['result'] = result['result'].to_f
      if counter == 0
        min_time = max_time = result['check_time']
        min_val = max_val = result
      else
        min_val = result if result['result'] < min_val['result']
        max_val = result if result['result'] > max_val['result']
        min_time = [min_time, result['check_time']].min
        max_time = [max_time, result['check_time']].max
      end

      counter += 1
      total += 1
      if total <= border
        num_per_group_ = num_per_group + 1
      else
        num_per_group_ = num_per_group
      end

      if counter == num_per_group_ || total == index_result.count
        aggregated_results << {
          'min' => min_val,
          'max'=> max_val,
          'start_time'=> min_time,
          'end_time'=> max_time,
          'count' => counter
        }
        counter = 0
      end
    end

    aggregated_results
  end

  #def is_number?(object)
  #  return false if object.nil?
  #  true if Float(object) rescue false
  #end

end
