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

  private

  def part_params
    params.select{|key,value| key.in?(Part.column_names())}.symbolize_keys
  end
end
