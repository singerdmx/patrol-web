class CheckPointsController < ApplicationController
  include CheckPointsHelper
  before_action :set_check_point, only: [:show, :edit, :update, :destroy]
  #TODO: disable user role for CUD of points
  # GET /check_points
  # GET /check_points.json
  def index
    @check_points = CheckPoint.where(check_point_params)

    if params[:ui] == 'true'
      @check_points_json = index_ui_json_builder(@check_points)
    else
      @check_points_json = index_json_builder(@check_points)
    end

    if stale?(etag: @check_points_json,
              last_modified: @check_points.maximum(:updated_at))
      render template: 'check_points/index', status: :ok
    else
      head :not_modified
    end

  rescue Exception => e
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
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  def new
    @check_point = CheckPoint.new
  end


  # POST /check_points
  # POST /check_points.json
  def create
    begin
      unless current_user.is_admin?
        render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
        return
      end

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
      render template: 'check_points/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_points/1
  # PATCH/PUT /check_points/1.json
  def update
    respond_to do |format|
      if @check_point.update(check_point_params)
        format.html { redirect_to @check_point, notice: 'Check Point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @check_point.errors, status: :internal_server_error }
      end
    end

  end

  # DELETE /check_points/1
  # DELETE /check_points/1.json
  def destroy
    unless current_user.is_admin?
      render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    CheckPoint.find(params[:id]).destroy
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error while deleting user #{params.inspect}: #{e}")
    render json: {:message => e.to_s}.to_json, status: :unprocessable_entity
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
