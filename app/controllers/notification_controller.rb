class NotificationController < ApplicationController
  def index
    @notifications_json = []
    now = Time.now
    last_modified = now
    current_user.all_points.each { |point|
      last_check_time = point.check_results.maximum(:check_time)
      if last_check_time.nil?
          @notifications_json<<  "#{point.name}  #{point.barcode}  从未检查过"
      else
          last_check_time + point.frequency * 3600 < now
          @notifications_json<<  "#{point.name}  #{point.barcode}  巡检到期, 上次检查时间 : #{last_check_time.localtime}"
          last_modified = [last_modified, last_check_time].min
      end
    }
    if stale?(etag: @notifications_json, last_modified: last_modified)
      render template: 'notification/index', status: :ok
    else
      head :not_modified
    end
  end
end
