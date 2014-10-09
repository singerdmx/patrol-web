class GraphsController < ApplicationController

  # sample url: http://localhost:3000/graphs?check_point_id=3&type=pareto&check_time=1404111600..1412838000
  def show
    point = CheckPoint.find(params[:check_point_id])

    puts params[:type]
    unless params[:check_time].nil?
      update_check_time(params)
    end
    puts params[:check_time]

    case point.category
      when 40, 41
        @results = CheckResult.where(check_result_params).group(:result).count
      else
        fail "Category #{point.category} is supported!"
    end

  rescue Exception => e
    flash[:error] = e.message
  end
end
