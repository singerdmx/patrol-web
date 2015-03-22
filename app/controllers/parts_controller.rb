class PartsController < ApplicationController
  include PartsHelper

  # GET /parts.json
  def index
    ActiveRecord::Base.transaction do
      parts = Part.where(part_params).where(tombstone: false)

      parts_json = index_json_builder(parts)
      if stale?(etag: @check_points_json,
                last_modified: parts.maximum(:updated_at))
        render json: parts_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  end

  # POST /part.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      if part_params[:asset_id].nil?
        logger.info("no asset id provided when creating part:so creating dummy asset")
        asset = Asset.create({
                               barcode: part_params[:barcode],
                               name: part_params[:name],
                               description: part_params[:description]
                             })
      else
        asset = Asset.find(part_params[:asset_id])
      end

      part = asset.parts.create!(part_params)
      render json: part.to_json, status: :created
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # PATCH/PUT /parts/1.json
  def update
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    part = Part.find(params[:id])
    if part.update(part_params)
      render nothing: true
    else
      fail 'Update failed'
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # DELETE /parts/1.json
  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    Part.find(params[:id]).update_attributes(tombstone: true)
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  private

  def part_params
    params.select{|key,value| key.in?(Part.column_names())}.symbolize_keys
  end
end
