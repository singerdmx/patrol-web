class PartsController < ApplicationController
  include PartsHelper

  # GET /parts.json
  def index
    ActiveRecord::Base.transaction do
      parts = Part.where(part_params)

      parts_json = index_json_builder(parts)
      if stale?(etag: @check_points_json,
                last_modified: parts.maximum(:updated_at))
        render json: parts_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  end

  # DELETE /parts/1.json
  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    Part.find(params[:id]).destroy
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
