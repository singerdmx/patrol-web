class RepairReportsController < ApplicationController
  include RepairReportsHelper

  # GET /repair_reports.json
  # http://localhost:3000/parts/A001/history.json?chart=true&check_time=1416038400..1424764800&barcode=true
  def index
    if params[:part_id] and params[:barcode] == 'true'
      part = Part.find_by(barcode: params[:part_id])
      if part.nil?
        render json: { error: "无法找到条形码为\"#{params[:part_id]}\"的部件" }.to_json, status: :not_found
        return
      else
        params[:part_id] = part.id
      end
    end

    ActiveRecord::Base.transaction do
      if params[:chart] == 'true'
        check_time = convert_check_time(params)[:check_time]
        reports = RepairReport.where(part_id: params[:part_id]).order(created_at: :asc)
        reports_json = index_json_chart_builder(reports, params[:part_id], check_time)
      else
        reports = RepairReport.where(created_by_id: current_user.id)
        reports_json = index_json_builder(reports)
      end

      if stale?(etag: reports_json,
                last_modified: reports.maximum(:updated_at))
        render json: reports_json.to_json
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # POST /repair_reports.json
  def create
    fail "no data when trying to create repair report!" if params[:repairReports].blank? && params[:ticketUpdates].blank?

    ActiveRecord::Base.transaction do
      create_repair_report(params[:repairReports])
      update_repair_report(params[:ticketUpdates])
    end

    render nothing: true, status: :created
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def repair_report_params
    request_para = params[:repair_report].nil? ? params : params[:repair_report]
    request_para.select{|key,value| key.in?(RepairReport.column_names())}.symbolize_keys
  end

  def create_repair_report(repair_reports)
    return if repair_reports.blank?
    repair_reports.each do |repair_report|
      repair_report['created_by_id'] = current_user.id
      report_params = repair_report.select do |key, value|
        key.in?(RepairReport.column_names())
      end.symbolize_keys
      report = RepairReport.create!(report_params)
      update_part_status(report)
    end
  end

  def update_repair_report(ticket_updates)
    return if ticket_updates.blank?
    ticket_updates.each do |ticket_update|
      report = RepairReport.find(ticket_update[:id])
      report.update(status: ticket_update[:status])
      update_part_status(report)
    end
  end
end
