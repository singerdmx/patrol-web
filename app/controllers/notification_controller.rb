class NotificationController < ApplicationController
  def index
    @notifications_json = []
    now = Time.now
    current_user.all_points.each { |point|
      last_check_time = point.check_results.maximum(:check_time)
      logger.info("last_check_time : #{last_check_time}")
      if !last_check_time.nil? &&  last_check_time + point.frequency * 3600 < now

        @notifications_json<<  "点 #{point.id} #{point.name} 检修超期"
      end

    }
    render template: 'notification/index', status: :ok


  end
end
