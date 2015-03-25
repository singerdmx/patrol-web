class ProblemListController < ApplicationController
  include ProblemListHelper, RepairReportsHelper

  # GET /problem_list.json
  # Example http://localhost:3000/problem_list.json?ui=true&status=2
  def index
    ActiveRecord::Base.transaction do
      reports = query_repair_report(params)
      reports_json = index_json_builder(reports)

      if params[:ui] == 'true'
        reports_json = problem_list_ui_json_builder(reports_json)
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

  # GET /problem_list/1.json
  def show
    ActiveRecord::Base.transaction do
      report = db_result_to_hash(RepairReport.find(params[:id]))
      render json: report.to_json
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # PUT /problem_list/1.json
  def update
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    report = RepairReport.find(params[:id])

    new_value = {
      status: params[:status],
      content: params[:content],
    }
    new_value[:plan_date] = Time.at(params[:plan_date]).to_date if params[:plan_date]
    new_value[:assigned_to_id] = params[:assigned_to_id] unless params[:assigned_to_id].blank?

    ActiveRecord::Base.transaction do
      report.update_attributes(new_value)
      update_part_status(report)
    end

    render json: {id: params[:id]}.to_json
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # GET /problem_list/export.json
  def export
    reports = query_repair_report(params)
    send_data reports.to_csv,
              type: 'text/csv; charset=UTF-8;',
              disposition: "attachment; filename=reports.txt"
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def query_repair_report(params)
    if params[:status] and params[:status].to_i != 0
      RepairReport.where(status: params[:status].to_i)
    else
      RepairReport.all
    end
  end
end
