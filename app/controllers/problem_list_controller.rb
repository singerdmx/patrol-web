class ProblemListController < ApplicationController
  include ProblemListHelper

  # GET /problem_lists
  # GET /problem_lists.json
  def index
    # @reports = RepairReport.where(:created_by_id => current_user.id)
    @reports = RepairReport.all

    @reports_index_json = index_json_builder(@reports)
  rescue Exception => e
    flash[:error] = e.message
  end
end
