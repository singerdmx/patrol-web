class GraphsController < ApplicationController

  # sample url: http://localhost:3000/graphs?type=pareto&check_time=1404111600..1412838000
  def show
    puts params[:type]
    unless params[:check_time].nil?
      update_check_time(params)
    end
    puts params[:check_time]
  end
end
