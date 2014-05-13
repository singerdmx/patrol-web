class CheckResultsController < ApplicationController
  include CheckResultsHelper
  before_action :set_check_result, only: [:show, :edit, :update, :destroy]

  # GET /check_results
  # GET /check_results.json
  def index
    if !params[:check_point_id].nil? && params[:barcode] == 'true'
      params[:check_point_id] = CheckPoint.where({:barcode => params[:check_point_id]}).take!.id
    end

    index_para = check_result_params

    if !index_para[:check_time].nil?&&index_para[:check_time].include?('..')
       time_window = index_para[:check_time].split('..')
       index_para[:check_time] = Time.at(time_window[0].to_i).to_datetime..Time.at(time_window[1].to_i).to_datetime
    end
    @check_results = get_results(index_para, params[:preference]=='true')
    @check_results_json = index_json_builder(@check_results, params)

    if params[:ui] == 'true'
      @check_results_json = index_ui_json_builder(@check_results_json)
    end

    if stale?(etag: @check_results_json,
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
      if params[:points].nil?
        #TODO: this if branch need to be removed
        @check_result = CheckResult.create!(check_result_params)
        render template: 'check_results/show', status: :created
      else
        #batch upload from client with time in number of seconds since epoch time
        start_time_ = Time.at(params[:start_time]).to_datetime
        end_time_ = Time.at(params[:end_time]).to_datetime

        route_sessions = Hash.new

        params[:points].each { |point|
          #TODO: the following validation is commented out due to that user b may submit for user a. may need better logic
          # for this
          #next if !User.validate(point['id'])
          route_ids = point['routes']
          check_time_ =  Time.at(point['check_time']).to_datetime
          route_ids.each { |route_id|
            route = CheckRoute.find(route_id)
            if route_sessions[route_id].nil?
              route_sessions[route_id]  = route.check_sessions.create!({user: params[:user],
                                                    start_time: start_time_,
                                                    end_time: end_time_,
                                                    session: params[:session]})
            end
            CheckResult.create!({check_session_id: route_sessions[route_id].id,
                                 check_point_id: point['id'],
                                 check_time: check_time_,
                                 result: point['result'],
                                 status: point['status'],
                                 memo: point['memo']})

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
      @check_result = get_results({id: params[:id]}).take!
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_result_params
      request_para = params[:check_result].nil? ? params : params[:check_result]
      request_para.select{|key,value| key.in?(CheckResult.column_names())}.symbolize_keys
    end
end
