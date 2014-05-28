class NotificationController < ApplicationController
  def index
    @notifications_json = []
    now = Time.now
    last_modified = nil
    previous_modified = request.headers["Last-Modified"]
    previous_modified = Time.parse(previous_modified) if  !previous_modified.nil?
    current_user.all_points.each { |point|
      last_check_time = point.check_results.maximum(:check_time)
      if last_check_time.nil?
          #TODO : do we need to care those never checked?
          @notifications_json<<  "#{point.name}  #{point.barcode}  从未检查过"
      elsif last_check_time + point.frequency * 3600 < now && (previous_modified.nil? || last_check_time> previous_modified)
          @notifications_json<<  "#{point.name}  #{point.barcode}  巡检到期, 上次检查时间 : #{last_check_time.localtime}"
          if  last_modified.nil?
            last_modified = last_check_time
          elsif
            last_modified = [last_modified, last_check_time].max
          end

      end
    }

    last_modified = previous_modified if  @notifications_json.empty?
    if stale?(etag: @notifications_json, last_modified: last_modified)
      render template: 'notification/index', status: :ok
    else
      head :not_modified
    end
  end
end
