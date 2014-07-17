class RouteOperationController < ApplicationController

  def update
    unless current_user.is_admin?
      render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    params[:check_route_id]
    params[:point]
    render json: { success: true }.to_json, status: :ok
  end
end