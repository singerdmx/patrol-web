class PartsController < ApplicationController
  include PartsHelper

  # GET /parts.json
  def index
    ActiveRecord::Base.transaction do
      parts = Part.where(part_params).where(tombstone: false)

      if params[:ui] == 'true'
        parts_json = index_ui_json_builder(parts)
      else
        parts_json = index_json_builder(parts)
      end
      if stale?(etag: parts_json,
                last_modified: parts.maximum(:updated_at))
        render json: parts_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  end

  # GET /parts/1.json
  def show
    ActiveRecord::Base.transaction do
      part = Part.find(params[:id])
      p = to_hash(part)
      p['default_assigned_user'] = User.find(p['default_assigned_id']).name if p['default_assigned_id']
      p['asset'] = to_hash(Asset.find(p['asset_id']))
      render json: p.to_json
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  # POST /part.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      if part_params[:asset_id].nil?
        asset = create_dummy_asset(part_params)
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

    if Part.find(params[:id]).update(part_params)
      render json: {id: params[:id]}.to_json
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

    ActiveRecord::Base.transaction do
      part = Part.find(params[:id])
      delete_dummy_asset(part)
      part.update_attributes(tombstone: true)
    end
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
