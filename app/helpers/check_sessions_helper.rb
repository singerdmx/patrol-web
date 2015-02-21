module CheckSessionsHelper
  include ApplicationHelper

  def index_ui_json_builder(check_sessions_json)
    check_sessions_json.map do |entry|
      [
        entry.id,
        entry.check_route.description,
        entry.start_time.to_i,
        entry.end_time.to_i,
        entry.user
      ]
    end
  end

end
