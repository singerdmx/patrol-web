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
    params['created_by_id'] = current_user.id
    report = params.select do |key, value|
      key.in?(RepairReport.column_names())
    end.symbolize_keys

    RepairReport.create!(report)
    render nothing: true, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
