class ManualsController < ApplicationController

  # GET /manuals.json
  def index
    manuals = {}
    all_manuals = Manual.where(tombstone: false)
    all_manuals.all.each do |m|
      manuals[m[:id]] = m[:entry]
    end
    if stale?(etag: manuals, last_modified: all_manuals.maximum(:updated_at))
      render json: manuals.to_json
    else
      head :not_modified
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
