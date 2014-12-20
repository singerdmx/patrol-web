class ProblemListController < ApplicationController
  include ProblemListHelper

  # GET /problem_list.json
  def index
    reports = RepairReport.where("check_result_id is not null")
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
