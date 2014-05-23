class NotificationController < ApplicationController
  def index
    @notifications_json = []
    now = Time.now
    current_user.all_points.each { |point|
      last_check_time = point.check_results.maximum(:check_time)
      if !last_check_time.nil? &&  last_check_time + point.frequency * 3600 < now
          @notifications_json<<  "#{point.name}  #{point.barcode}  巡检到期"
      end
    }
    if stale?(etag: @notifications_json)
      render template: 'notification/index', status: :ok
    else
      head :not_modified
    end
  end
end
