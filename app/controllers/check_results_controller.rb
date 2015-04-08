require 'set'

class CheckResultsController < ApplicationController
  include CheckResultsHelper, ProblemListHelper

  # GET /check_results.json
  # Example: http://localhost:3000/results.json?check_time=1424332800..1424505600&&ui=true&check_session_id=8
  # http://localhost:3000/points/A001/history.json?aggregate=30&check_time=1416038400..1424764800&barcode=true
  def index
    if params[:check_point_id] and params[:barcode] == 'true'
      point = CheckPoint.find_by(barcode: params[:check_point_id])
      if point.nil?
        render json: { error: "无法找到条形码为\"#{params[:check_point_id]}\"的巡检点" }.to_json, status: :not_found
        return
      else
        params[:check_point_id] = point.id
      end
    end

    index_para = convert_check_time(check_result_params)
    ActiveRecord::Base.transaction do
      @check_results = get_results(index_para, params[:preference]=='true')
      @check_results_json = index_json_builder(@check_results, params[:check_point_id])

      if params[:ui] == 'true'
        @check_results_json = index_ui_json_builder(@check_results_json)
      end

      if stale?(etag: @check_results_json,
                last_modified: @check_results.maximum(:updated_at))
        render json: @check_results_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # POST /check_results
  # POST /check_results.json
  def create
    fail "no points when trying to create result!" if params[:points].blank?

    # batch upload from client with time in number of seconds since epoch time
    start_time_ = Time.at(params[:start_time]).to_datetime
    end_time_ = Time.at(params[:end_time]).to_datetime

    route_sessions = Hash.new
    reports = []
    contacts = Set.new
    users = Set.new([current_user.id])
    ActiveRecord::Base.transaction do
      params[:points].each do |point|
        create_point_result(reports, contacts, users, point, route_sessions, start_time_, end_time_)
      end

      send_emails(reports, contacts, users)
    end

    render nothing: true, status: :created
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # GET /results/export.json
  def export
    index_para = convert_check_time(check_result_params)
    results = get_results(index_para, params[:preference]=='true')
    send_data results.to_csv,
              type: 'text/csv; charset=UTF-8;',
              disposition: "attachment; filename=results.txt"
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_result_params
    request_para = params[:check_result].nil? ? params : params[:check_result]
    request_para.select{|key,value| key.in?(CheckResult.column_names())}.symbolize_keys
  end

  def create_point_result(reports, contacts, users, point, route_sessions, start_time_, end_time_)
    route_ids = point['routes']
    check_time_ = Time.at(point['check_time']).to_datetime
    route_ids.each do |route_id|
      route = CheckRoute.find(route_id)
      if route_sessions[route_id].nil?
        route_sessions[route_id]  = route.check_sessions.create!(
          user: params[:user],    # submitter
          start_time: start_time_,
          end_time: end_time_,
          session: params[:session])
      end

      check_result_input = {
        check_session_id: route_sessions[route_id].id,
        check_point_id: point['id'],
        check_time: check_time_,
        result: point['result'],
        status: point['status'],
        memo: point['memo'],
        area_id: route.area.id,
        result_image_id: point['image'],
        result_audio_id: point['audio']
      }
      Rails.logger.info("creating check_result #{check_result_input}")

      result_record = CheckResult.create!(check_result_input)

      if point['status'] == 1
        reports << create_repair_report(route, users, check_time_, point, result_record)
        contacts.merge(JSON.parse(route.contacts).map {|c| c.to_i}) unless route.contacts.blank?
      end
    end
  end

  def create_repair_report(route, users, check_time_, point, result_record)
    check_point = CheckPoint.find(point['id'])
    users.add(check_point.default_assigned_id) if check_point.default_assigned_id
    repair_report_input = {
      asset_id: check_point.asset_id,
      check_point_id: point['id'],
      kind: 'POINT',
      code: 2,
      description: result_record.memo,
      content: '',
      created_by_id: current_user.id,
      priority: 1,
      status: 2,
      check_result_id: result_record.id,
      report_type: 2,
      assigned_to_id: check_point.default_assigned_id,
      created_at: check_time_,
      result_image_id: point['image'],
      result_audio_id: point['audio'],
      stopped: false,
      production_line_stopped: false,
      area_id: route.area.id,
      report_num: 'YYYYMMDD0000'
    }
    Rails.logger.info("creating repair_report #{repair_report_input}")
    report = RepairReport.create!(repair_report_input)
    set_report_num(report)
    report
  end

  def send_emails(reports, contacts, users)
    reports = reports.map { |r| db_result_to_hash(r) }
    email_content =
      problem_list_ui_json_builder(reports).map do |c|
        c[0] = Time.at(c[0]).strftime("%Y年%m月%d日")
        c[9] = c[9].nil? ? '' : Time.at(c[9]).strftime("%Y年%m月%d日")
        c
      end
    Rails.logger.info("sending email: #{email_content}")
    AlertMailer.alert_email(contacts, users, email_content).deliver
  end

end
