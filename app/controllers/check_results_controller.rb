class CheckResultsController < ApplicationController
  include CheckResultsHelper, ProblemListHelper
  before_action :set_check_result, only: [:show, :edit, :update, :destroy]

  # GET /check_results
  # GET /check_results.json
  def index
    begin
      if !params[:check_point_id].nil?
        if params[:barcode] == 'true'
          point = CheckPoint.find_by(barcode: params[:check_point_id])
          if point.nil?
            render json: { error: "无法找到条形码为\"#{params[:check_point_id]}\"的巡检点" }.to_json, status: :not_found
            return
          else
            params[:check_point_id] = point.id
          end
        end
      end

      index_para = convert_check_time(check_result_params)
      @check_results = get_results(index_para, params[:preference]=='true')
      @check_results_json = index_json_builder(@check_results)

      if params[:ui] == 'true'
        @check_results_json = index_ui_json_builder(@check_results_json)
      end

      if stale?(etag: @check_results_json,
                last_modified: @check_results.maximum(:updated_at))
        render template: 'check_results/index', status: :ok
      else
        head :not_modified
      end
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # GET /check_results/1
  # GET /check_results/1.json
  def show
  end



  # POST /check_results
  # POST /check_results.json
  def create
    fail "no points when trying to create result!" if params[:points].blank?

    #batch upload from client with time in number of seconds since epoch time
    start_time_ = Time.at(params[:start_time]).to_datetime
    end_time_ = Time.at(params[:end_time]).to_datetime

    route_sessions = Hash.new

    params[:points].each do |point|
      #TODO: the following validation is commented out due to that user b may submit for user a. may need better logic
      # for this
      #next if !User.validate(point['id'])
      route_ids = point['routes']
      check_time_ = Time.at(point['check_time']).to_datetime
      route_ids.each do |route_id|
        route = CheckRoute.find(route_id)
        if route_sessions[route_id].nil?
          route_sessions[route_id]  = route.check_sessions.create!(
            user: params[:user],
            start_time: start_time_,
            end_time: end_time_,
            session: params[:session])
        end

        result_record = CheckResult.create!(
          check_session_id: route_sessions[route_id].id,
          check_point_id: point['id'],
          check_time: check_time_,
          result: point['result'],
          status: point['status'],
          memo: point['memo'],
          result_image_id: point['image'])

        if point['status'] == 1
          check_point = CheckPoint.find(point['id'])
          report = RepairReport.create(
            asset_id: check_point.asset_id,
            check_point_id: point['id'],
            kind: "POINT",
            code: 2,
            description: result_record.memo,
            content: "",
            created_by_id: current_user.id,
            priority: 1,
            status: 2,
            check_result_id: result_record.id,
            report_type: "报修",
            assigned_to_id: check_point.default_assigned_id,
            created_at: check_time_
          )

          send_emails(check_point, report, route)
        end
      end
    end

    render nothing: true, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
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

  # GET /results/export.json
  def export
    index_para = convert_check_time(check_result_params)
    results = get_results(index_para, params[:preference]=='true')
    send_data results.to_xml,
              type: 'text/xml; charset=UTF-8;',
              disposition: "attachment; filename=results.xml"
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def convert_check_time(params)
    unless params[:check_time].nil?
      unless params[:check_time].include?('..') && params[:check_time].split('..').size == 2
        fail "Invalid check_time param #{params[:check_time]}"
      end

      time_window = params[:check_time].split('..')
      params[:check_time] = Time.at(time_window[0].to_i).to_datetime..Time.at(time_window[1].to_i).to_datetime
    end

    params
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_check_result
    @check_result = get_results({id: params[:id]}).take!
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_result_params
    request_para = params[:check_result].nil? ? params : params[:check_result]
    request_para.select{|key,value| key.in?(CheckResult.column_names())}.symbolize_keys
  end

  def send_emails(check_point, report, route)
    #Thread.new do
      contacts = route.contacts
      contacts = contacts[1...-1].split(",").map { |s| s[1...-1].to_i } if contacts
      users = [current_user.id]
      users << check_point.default_assigned_id if check_point.default_assigned_id

      email_content =
        problem_list_ui_json_builder([db_result_to_hash(report)]).map do |c|
          c[0] = Time.at(c[0]).strftime("%Y年%m月%d日")
          c[9] = c[9].nil? ? '' : Time.at(c[9]).strftime("%Y年%m月%d日")
          c
        end
      AlertMailer.alert_email(contacts, users, email_content).deliver
    end
  #end
end
