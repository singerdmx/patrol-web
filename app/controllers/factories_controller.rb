class FactoriesController < ApplicationController
  include FactoriesHelper

  # GET /factoriess.json
  def index
    if show_full_view?
      factories = Factory.all

      @factories_json = []
      factories.reverse.each do |f|
        entry = to_hash(f)
        entry['subfactories'] = []

        f.subfactories.reverse.each do |subf|
          subf_entry = to_hash(subf)
          subf_entry['areas'] = []

          subf.areas.reverse.each do |area|
            area_entry = to_hash(area)
            area_entry['routes'] = []
            area.check_routes.reverse.each do |r|
              area_entry['routes'] << to_hash(r)
            end
            subf_entry['areas'] << area_entry
          end

          entry['subfactories'] << subf_entry
        end

        @factories_json << entry
      end

      if params[:ui] == 'true'
        @factories_json = index_ui_json_builder(@factories_json)
      end

      if stale?(etag: @factories_json.to_a,
                last_modified: factories.maximum(:updated_at))
        render template: 'factories/index', status: :ok
      else
        head :not_modified
      end
    else
      render json: {error: "此用户没有足够权限访问本页"}.to_json, status: :unauthorized
    end
  end
end
