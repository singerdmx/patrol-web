class ProblemListController < ApplicationController
  include ProblemListHelper

  # GET /problem_list.json
  # Example http://localhost:3000/problem_list.json?ui=true&status=2
  def index
    reports = RepairReport.where("check_result_id is not null")
    reports = reports.where(status: params[:status].to_i) if params[:status] and params[:status].to_i != 0
    reports_json = index_json_builder(reports)

    if params[:ui] == 'true'
      reports_json = index_ui_json_builder(reports_json)
    end

    if stale?(etag: reports_json,
              last_modified: reports.maximum(:updated_at))
      render json: reports_json.to_json
    else
      head :not_modified
    end
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # GET /problem_list/1.json
  def show
    report = db_result_to_hash(RepairReport.find(params[:id]))
    report['status'] = get_problem_status_string(report['status'])
    render json: report.to_json
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # PUT /problem_list/1.json
  def update
    puts params[:id]
    puts params[:plan_date] # nil if not specified
    puts params[:assigned_to_id] # "" if not specified
    render json: {}.to_json
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
