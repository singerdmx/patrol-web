class ManualsController < ApplicationController
  include ManualsHelper

  # GET /manuals.json
  def index
    ActiveRecord::Base.transaction do
      manuals = Manual.where(manual_params).where(tombstone: false)
      if params[:ui] == 'true'
        manuals_json = index_ui_json_builder(manuals)
      else
        manuals_json = index_json_builder(manuals)
      end

      if stale?(etag: manuals_json,
                last_modified: manuals.maximum(:updated_at))
        render json: manuals_json.to_json
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # POST /manuals.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    manual = Manual.create!(manual_params)
    render json: manual.to_json, status: :created
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def manual_params
    request_para = params[:manual].nil? ? params : params[:manual]
    request_para.select{|key,value| key.in?(Manual.column_names())}.symbolize_keys
  end
end
