require 'json'

module CheckResultsHelper
  include ApplicationHelper
  #replacement of the index.json.jbuilder for complicated converting logic
  def index_json_builder(index_result, params)
    results = []
    if params[:aggregate].nil?
      index_result.each do |entry|
        result = to_hash(entry)
        result['point'] = entry.check_point
        result['session'] = entry.check_session
        result.delete_if {|key, value| key.in?(['check_point_id', 'check_session_id', 'created_at', 'updated_at']) }
        results << result
      end
    elsif params[:aggregate] > 0
      num_per_group =  index_result.count / params[:aggregate]
      remainder =  index_result.count % params[:aggregate]
      border = remainder * (num_per_group+1)
      aggregated_results = [];
      counter = 0
      total = 0
      index_result.each do |entry|
        if counter == 0
          #TODO if result is not of numerical type, we cannot really compare for min/max so need to return a different
          #type of aggregation
          min_val = entry
          max_val = entry
          min_time = entry.check_time.to_i
          max_time = entry.check_time.to_i
        elsif !entry.result.nil? && is_number?(entry.result)
          min_val = min_val.result.to_f < entry.result.to_f ? min_val: entry
          max_val = max_val.result.to_f > entry.result.to_f ? max_val: entry
          min_time = [min_time, entry.check_time.to_i].min
          max_time = [max_time, entry.check_time.to_i].max
        end
        counter = counter+1
        total = total+1
        if  total <= border
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
      results = {'result' => aggregated_results}


      if !params[:check_point_id].nil?
        results['point'] = CheckPoint.find(check_result_params[:check_point_id])
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
    results = CheckResult.where(check_result_params).order(check_time: :asc)

    results

  end
  private
    def is_number?(object)
      true if Float(object) rescue false
    end

end
