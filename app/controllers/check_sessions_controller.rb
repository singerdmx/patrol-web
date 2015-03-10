class CheckSessionsController < ApplicationController
  include CheckSessionsHelper

  # GET /sessions.json
  # Example, http://localhost:3000/sessions.json?check_time=1424332800..1424505600&ui=true
  def index
    ActiveRecord::Base.transaction do
      sessions = CheckSession.where(
        params.select{|key,value| key.in?(CheckSession.column_names())}.symbolize_keys)
      check_time = convert_check_time(params)[:check_time]
      if check_time
        sessions = sessions.where("start_time > ? and end_time < ?", check_time.first, check_time.last)
      end

      results = sessions
      if params[:ui] == 'true'
        results = index_ui_json_builder(sessions)
      end

      if stale?(etag: results,
                last_modified: sessions.maximum(:updated_at))
        render json: results.to_json
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # GET /sessions/1.json
  def show
    ActiveRecord::Base.transaction do
      s = to_hash(CheckSession.find(params[:id]))
      s['start_time'] = s['start_time'].to_i
      s['end_time'] = s['end_time'].to_i
      s['route'] = CheckRoute.find(s['check_route_id']).description
      render json: s.to_json
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

end
