class CheckPointsController < ApplicationController
  include CheckPointsHelper
  before_action :set_check_point, only: [:show, :update, :destroy]
  #TODO: disable user role for CUD of points
  # GET /check_points.json
  def index
    ActiveRecord::Base.transaction do
      @check_points = CheckPoint.where(check_point_params).where(tombstone: false)

      if params[:ui] == 'true'
        @check_points_json = index_ui_json_builder(@check_points)
      else
        @check_points_json = index_json_builder(@check_points)
      end

      if stale?(etag: @check_points_json,
                last_modified: @check_points.maximum(:updated_at))
        render json: @check_points_json.to_json
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # GET /check_points/1.json
  def show
    p = to_hash(@check_point)
    p['default_assigned_user'] = User.find(p['default_assigned_id']).name if p['default_assigned_id']
    p['asset'] = to_hash(Asset.find(p['asset_id']))

    p['routes'] = @check_point.check_routes.map do |r|
      to_hash(r)
    end
    render json: p.to_json
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  # POST /check_points
  # POST /check_points.json
  def create
    begin
      unless current_user.is_admin?
        render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
        return
      end

      ActiveRecord::Base.transaction do
        if check_point_params[:asset_id].nil?
          logger.info("no asset id provided when creating point:so creating dummy asset")
          asset = Asset.create({
                                   barcode: check_point_params[:barcode],
                                   name: check_point_params[:name],
                                   description: check_point_params[:description] })
        else
          logger.info("asset id: #{check_point_params}")
          asset = Asset.find(check_point_params[:asset_id])
        end

        @check_point = asset.check_points.create!(check_point_params)
      end
      render json: @check_point.to_json, status: :created
    rescue Exception => e
      Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
      render json: {message: e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_points/1.json
  def update
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    if @check_point.update(check_point_params.except(:category, :choice))
      render json: {id: @check_point.id}.to_json
    else
      fail 'Update failed'
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # DELETE /check_points/1
  # DELETE /check_points/1.json
  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      CheckPoint.find(params[:id]).update_attributes(tombstone: true)
      UserPreference.where(check_point_id: params[:id]).delete_all
    end
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_point
      @check_point = CheckPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_point_params
      request_para = params[:check_point].nil? ? params : params[:check_point]
      request_para.select{|key,value| key.in?(CheckPoint.column_names())}.symbolize_keys
    end
end
