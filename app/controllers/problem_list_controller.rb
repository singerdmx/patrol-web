class ProblemListController < ApplicationController
  include ProblemListHelper

  # GET /problem_lists
  # GET /problem_lists.json
  def index
    @reports = RepairReport.where("check_session_id is not null")

    @reports_index_json = index_json_builder(@reports)
  rescue Exception => e
    flash[:error] = e.message
  end
end
