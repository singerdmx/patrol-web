class ManualsController < ApplicationController

  # GET /manuals.json
  def index
    manuals = {}
    Manual.all.each do |m|
      manuals[m[:id]] = m[:entry]
    end
    if stale?(etag: manuals)
      render json: manuals.to_json
    else
      head :not_modified
    end
  end
end
