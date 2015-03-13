module CheckSessionsHelper
  include ApplicationHelper

  def index_ui_json_builder(check_sessions_json)
    check_sessions_json.map do |entry|
      email = entry.user # entry.user may be "OFFLINE"
      user = User.find_by_email(email)
      user = user.name if user
      [
        entry.id,
        entry.check_route.description,
        entry.start_time.to_i,
        entry.end_time.to_i,
        user,
        email
      ]
    end
  end

end
