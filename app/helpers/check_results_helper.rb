require 'json'

module CheckResultsHelper
  include ApplicationHelper
  def index_json_builder(index_result, check_point_id)
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
      results['group'] = true if index_result.size > group

      if params[:check_point_id]
        results['point'] = to_hash(CheckPoint.find(check_point_id))
      end
      case results['point']['category']
        when 30, 50
          results['result'] = aggregate_numeric_results(index_result, group)
        when 40, 41
          results['result'] = aggregate_enumerable_results(index_result, group, JSON.parse(results['point']['choice']))
        when 10,20
          results['result'] = index_result.size
        when 51
          results['result'] = aggregate_status_results(index_result, group, JSON.parse(results['point']['choice']))
        else
          results['result'] = []
      end
    end

    results
  end

  def index_ui_json_builder(check_results_json)
    check_results_json.map do |result|
      status = get_check_result_status_string(result['status'])
      result['image'] =  ResultImage.find(result['result_image_id']).url if result['result_image_id']
      result['audio'] =  ResultAudio.find(result['result_audio_id']).url if result['result_audio_id']

      [
        result['point']['name'],
        result['point']['description'],
        result['area_id'].nil? ? "" : Area.find(result['area_id']).name,
        result['result'],
        get_point_standard(result),
        status,
        result['memo'],
        result['point']['barcode'],
        result['check_time'].to_i,
        [result['image'], result['audio']],
        result['session'].id
      ]
    end
  end

  def get_results(check_result_params, preferred = false)
    if user_signed_in?
      if preferred
        check_result_params[:check_point_id] = current_user
                                                 .preferred_points
                                                 .map { |p| p.id }
      elsif current_user.is_user?
        points = current_user.all_points.map { |p| p.id }
        if check_result_params[:check_point_id].nil?
          check_result_params[:check_point_id] = points
        else
          # Restrict normal user to view own points only. Here assume check_result_params[:check_point_id] has one id only, not array
          return CheckResult.none if !points.include?(check_result_params[:check_point_id].to_i)
        end
      end
    end

    results = CheckResult.where(check_result_params)

    results.order(check_time: :asc)
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

  def aggregate_enumerable_results(index_result, group, choice)
    num_per_group =  index_result.count / group
    remainder =  index_result.count % group
    border = remainder * (num_per_group+1)
    aggregated_results = []
    total = counter = 0
    min_time = max_time = nil
    selection = Array.new(choice.size, 0)
    index_result.each do |entry|
      result = to_hash(entry)
      logger.info(result)
      index = choice.index(result['result'])
      fail "Choice #{choice.inspect} does not have #{result['result']}" unless index
      result['check_time'] = result['check_time'].to_i
      if counter == 0
        min_time = max_time = result['check_time']
      else
        min_time = [min_time, result['check_time']].min
        max_time = [max_time, result['check_time']].max
      end

      selection[index] += 1
      counter += 1
      total += 1
      if total <= border
        num_per_group_ = num_per_group + 1
      else
        num_per_group_ = num_per_group
      end

      if counter == num_per_group_ || total == index_result.count
        aggregated_results << {
          'selection' => selection,
          'start_time' => min_time,
          'end_time' => max_time,
          'count' => counter
        }
        selection = Array.new(choice.size, 0)
        counter = 0
      end
    end

    aggregated_results
  end

  def aggregate_status_results(index_result, group, choice)
    num_per_group =  index_result.count / group
    remainder =  index_result.count % group
    border = remainder * (num_per_group+1)
    aggregated_results = []
    total = counter = 0
    min_time = max_time = nil
    selection = Array.new(choice.size, 0)
    index_result.each do |entry|
      result = to_hash(entry)
      logger.info(result)
      fail "Choice #{choice.inspect} does not have status #{result['status']}" unless choice[result['status']]
      result['check_time'] = result['check_time'].to_i
      if counter == 0
        min_time = max_time = result['check_time']
      else
        min_time = [min_time, result['check_time']].min
        max_time = [max_time, result['check_time']].max
      end

      selection[result['status']] += 1
      counter += 1
      total += 1
      if total <= border
        num_per_group_ = num_per_group + 1
      else
        num_per_group_ = num_per_group
      end

      if counter == num_per_group_ || total == index_result.count
        aggregated_results << {
          'selection' => selection,
          'start_time' => min_time,
          'end_time' => max_time,
          'count' => counter
        }
        selection = Array.new(choice.size, 0)
        counter = 0
      end
    end

    aggregated_results
  end

  private

  def get_check_result_status_string(status)
    case status
      when 0 then '正常'
      when 1 then '异常'
      when 2 then '警告'
      else '未知'
    end
  end

end
