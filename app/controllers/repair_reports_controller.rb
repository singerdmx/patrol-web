class RepairReportsController < ApplicationController
  include RepairReportsHelper

  # GET /repair_reports
  # GET /repair_reports.json
  def index
    ActiveRecord::Base.transaction do
      reports = RepairReport.where(created_by_id: current_user.id)
      reports_json = index_json_builder(reports)

      if stale?(etag: reports_json,
                last_modified: reports.maximum(:updated_at))
        render json: reports_json.to_json
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    flash[:error] = e.message
  end

  # POST /repair_reports.json
  def create
    fail "no data when trying to create repair report!" if params[:repairReports].blank? && params[:ticketUpdates].blank?

    start_time_ = Time.at(params[:start_time]).to_datetime
    end_time_ = Time.at(params[:end_time]).to_datetime

    create_repair_report(params[:repairReports])
    update_repair_report(params[:ticketUpdates])

    render nothing: true, status: :created
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def create_repair_report(repair_reports)
    return if repair_reports.blank?
    repair_reports.each do |repair_report|
      repair_report['created_by_id'] = current_user.id
      report = repair_report.select do |key, value|
        key.in?(RepairReport.column_names())
      end.symbolize_keys
      RepairReport.create!(report)
    end
  end

  def update_repair_report(ticket_updates)
    return if ticket_updates.blank?
    ticket_updates.each do |ticket_update|
      report = RepairReport.find(ticket_update[:id])
      report.update(status: ticket_update[:status])
    end
  end
end
