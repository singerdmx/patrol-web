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
end
