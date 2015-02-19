class RepairReportsController < ApplicationController
  include RepairReportsHelper

  # GET /repair_reports
  # GET /repair_reports.json
  def index
    @reports = RepairReport.where(:created_by_id => current_user.id)

    @reports_index_json = index_json_builder(@reports)
  rescue Exception => e
    flash[:error] = e.message
  end

  # POST /repair_reports.json
  def create
    fail "no data when trying to create repair report!" if params[:repairReports].blank? && params[:ticketUpdates].blank?

    start_time_ = Time.at(params[:start_time]).to_datetime
    end_time_ = Time.at(params[:end_time]).to_datetime

    params[:repairReports].each do |repair_report|
      repair_report['created_by_id'] = current_user.id
      report = repair_report.select do |key, value|
        key.in?(RepairReport.column_names())
      end.symbolize_keys
      RepairReport.create!(report)
    end

    render nothing: true, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
