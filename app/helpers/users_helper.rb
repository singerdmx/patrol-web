module UsersHelper
  include ApplicationHelper

  def index_ui_json_builder(index_result)
    results = index_result.map do |entry|
      [
        entry['id'],
        entry['name'],
        entry['email'],
        entry['role'],
        entry['current_sign_in_at'].nil? ? nil : entry['current_sign_in_at'].to_i,
        entry['last_sign_in_at'].nil? ? nil : entry['last_sign_in_at'].to_i,
        entry['current_sign_in_ip'],
        entry['last_sign_in_ip'],
        entry['created_at'].to_i,
        entry['updated_at'].to_i
      ]
    end

    results.sort_by { |u| u[3] } # order by role
  end
end
