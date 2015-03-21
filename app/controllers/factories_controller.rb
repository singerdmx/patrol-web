class FactoriesController < ApplicationController
  include FactoriesHelper

  # GET /factoriess.json
  def index
    if !show_full_view?
      render json: {error: "此用户没有足够权限访问本页"}.to_json, status: :unauthorized
      return
    end

    factories_json = []
    ActiveRecord::Base.transaction do
      factories = Factory.where(tombstone: false)
      factories.reverse.each do |f|
        entry = to_hash(f)
        entry['subfactories'] = []

        f.subfactories.select{|s| !s.tombstone}.reverse.each do |subf|
          subf_entry = to_hash(subf)
          subf_entry['areas'] = []

          subf.areas.select{|a| !a.tombstone}.reverse.each do |area|
            area_entry = to_hash(area)
            area_entry['routes'] = []
            area.check_routes.select{|r| !r.tombstone}.reverse.each do |r|
              area_entry['routes'] << to_hash(r)
            end
            subf_entry['areas'] << area_entry
          end

          entry['subfactories'] << subf_entry
        end

        factories_json << entry
      end

      if params[:ui] == 'true'
        factories_json = index_ui_json_builder(factories_json)
      end

      if stale?(etag: factories_json.to_a,
                last_modified: factories.maximum(:updated_at))
        render json: factories_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end
end
