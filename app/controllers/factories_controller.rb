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
          subfentry = to_hash(subf)
          subfentry['areas'] = []

          subf.areas.reverse.each do |area|
            areaentry = to_hash(area)
            areaentry['routes'] = []
            area.check_routes.reverse.each do |r|
              areaentry['routes'] << to_hash(r)
            end
            subfentry['areas'] << areaentry
          end

          entry['subfactories'] << subfentry
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
