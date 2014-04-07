class CheckResultsController < ApplicationController
  before_action :set_check_result, only: [:show, :edit, :update, :destroy]

  # GET /check_results
  # GET /check_results.json
  def index
    @check_results = CheckResult.where(check_result_params)
    if stale?(etag: @check_results.to_a,
              last_modified: @check_results.maximum(:updated_at))
      render template: 'check_results/index', status: :ok
    else
      head :not_modified
    end
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
      if params[:assets].nil?
        @check_result = CheckResult.create!(check_result_params)
        render template: 'check_results/show', status: :created
      else
        #batch upload from client with time in number of seconds since epoch time
        route = CheckRoute.find(params[:check_route_id])
        session = route.sessions.create!({user: params[:user],
                                          start_time: Time.at(params[:start_time]).to_datetime,
                                          end_time: Time.at(params[:end_time]).to_datetime,
                                          session: params[:session]})
        params[:assets].each { |asset|
          asset.points.each{|point|
            CheckResult.create!({check_session_id: session.id,
                                 check_point_id: point.id,
                                 check_time: Time.at(point.check_time).to_datetime,
                                 result: point.result,
                                 value: point.value})
          }
        }
        render :nothing => true, :status => :created
      end


    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_results/1
  # PATCH/PUT /check_results/1.json
  def update
    respond_to do |format|
      if @check_result.update(check_result_params)
        format.html { redirect_to @check_result, notice: 'Check Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @check_result.errors, status: :internal_server_error }
      end
    end

  end

  # DELETE /check_results/1
  # DELETE /check_results/1.json
  def destroy
    respond_to do |format|
      if @check_result.destroy
        format.html { redirect_to action: :index }
        format.json { render :nothing => true, :status => :ok}
      else
        #TODO: better message for deletion failure
        format.html { redirect_to action: :index}
        format.json { render json: {:message=> e.to_s}.to_json, status: :internal_server_error }
      end
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_result
      @check_result = CheckResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_result_params
      request_para = params[:check_result].nil? ? params : params[:check_result]
      request_para.select{|key,value| key.in?(CheckResult.column_names())}.symbolize_keys
    end
end
