class CheckResultsController < ApplicationController
  before_action :set_check_result, only: [:show, :edit, :update, :destroy]

  # GET /check_results
  # GET /check_results.json
  def index
    @check_results = CheckResult.all
  end

  # GET /check_results/1
  # GET /check_results/1.json
  def show
  end


  # POST /check_results
  # POST /check_results.json
  def create
    begin
      #TODO : validate incoming ids of route and point
      @check_result = CheckResult.create!(check_result_params)
      render template: 'check_results/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_results/1
  # PATCH/PUT /check_results/1.json
  def update
    begin
      @check_result.update(check_route_params)
      #TODO : validate incoming ids of route and point
      render template: 'check_results/show', status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end

  end

  # DELETE /check_results/1
  # DELETE /check_results/1.json
  def destroy
    begin
      @check_result.destroy
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_result
      @check_result = CheckResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_result_params
      params.select{|key,value| key.in?(CheckResult.column_names())}
    end
end
