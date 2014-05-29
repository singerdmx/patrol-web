class FactoriesController < ApplicationController
  include ApplicationHelper

  # GET /factoriess.json
  def index
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

    if stale?(etag: @factories_json.to_a,
              last_modified: factories.maximum(:updated_at))
      render template: 'factories/index', status: :ok
    else
      head :not_modified
    end
  end
end
