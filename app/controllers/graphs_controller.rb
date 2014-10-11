class GraphsController < ApplicationController

  # sample url: http://localhost:3000/graphs?check_point_id=3&type=pareto&check_time=1404111600..1412838000
  def show
    @point = CheckPoint.find(params[:check_point_id])

    @type = params[:type]
    unless params[:check_time].nil?
      update_check_time(params)
      @startTime = params[:check_time].first.to_i * 1000
      @endTime = params[:check_time].last.to_i * 1000
    end

    fail "Invalid type #{@type}" unless ['default', 'horizontal bars', 'pareto', 'pie', 'exploded pie', 'doughnut'].include?(@type)

    case @point.category
      when 40, 41
        @results = CheckResult.where(check_result_params).group(:result).count
      else
        fail "Category #{point.category} is supported!"
    end
  rescue Exception => e
    flash[:error] = e.message
  end
end
