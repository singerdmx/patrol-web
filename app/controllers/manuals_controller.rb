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
end
