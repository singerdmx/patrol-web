class RouteOperationController < ApplicationController

  def update
    unless current_user.is_admin?
      render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    attachment = RouteBuilder.find_by(check_point_id: params[:point], check_route_id: params[:check_route_id])
    if attachment.nil?
      render json: {:message => "Point #{params[:point]} is not attached to route #{params[:check_route_id]}"}.to_json, status: :bad_request
      return
    end

    attachment.destroy
    render json: { success: true }.to_json, status: :ok
  end
end