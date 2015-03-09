class AssetsController < ApplicationController
  include AssetsHelper
  # GET /assets
  # GET /assets.json
  def index
    ActiveRecord::Base.transaction do
      assets = Asset.where(asset_params)
      if params[:ui] == 'true'
        assets_index_json =  index_ui_json_builder(assets)
      else
        assets_index_json =  index_json_builder(assets)
      end

      if stale?(etag: assets_index_json,
                last_modified: assets.maximum(:updated_at))
        render json: assets_index_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  # GET /assets/1
  # GET /assets/1.json
  # GET http://localhost:3000/assets/780672318863.json?barcode=true
  def show
    ActiveRecord::Base.transaction do
      asset = get_asset
      asset_hash = to_hash(asset)
      asset_hash['points'] = asset.check_points
      render json: asset_hash.to_json
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  # POST /assets
  # POST /assets.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      asset = Asset.create!(asset_params)
      for pointId in params[:points]
        point = CheckPoint.find(pointId)
        point.asset_id = asset.id
        point.save
      end

      render json: asset.to_json, status: :created
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    get_asset.destroy
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  #PUT /assets/1/attach_point?point=id
  def attach_point
    ActiveRecord::Base.transaction do
      point = CheckPoint.find(params[:point])
      point.asset_id = params[:asset_id]
      point.save
    end
    render json: { success: true }.to_json, status: :ok
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("Bad point id from parameter #{params[:point]}")
    render json: {message: "Bad point id from parameter #{params[:point]}"}, status: :bad_request
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_asset
    if params[:barcode] == 'true'
      asset = Asset.find_by(barcode: params[:id])
      fail "无法找到条形码为\"#{params[:id]}\"设备" if asset.nil?
      params[:id] = asset.id
    end

    Asset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def asset_params
    request_para = params[:asset].nil? ? params : params[:asset]
    request_para.select{|key,value| key.in?(Asset.column_names())}.symbolize_keys
  end
end
