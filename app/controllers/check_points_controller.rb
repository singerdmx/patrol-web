class CheckPointsController < ApplicationController
  before_action :set_check_point, only: [:show, :edit, :update, :destroy]

  # GET /check_points
  # GET /check_points.json
  def index

    @check_points = CheckPoint.where(check_point_params)
    if stale?(etag: @check_points.to_a,
              last_modified: @check_points.maximum(:updated_at))
      render template: 'check_points/index', status: :ok
    else
      head :not_modified
    end
  end

  # GET /check_points/1
  # GET /check_points/1.json
  def show
    begin
      render template: 'check_points/show',  status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end

  def new
    @check_point = CheckPoint.new
  end


  # POST /check_points
  # POST /check_points.json
  def create
    begin
      logger.info("asset id: #{check_point_params}")
      asset = Asset.find(check_point_params[:asset_id])
      @check_point = asset.check_points.create!(check_point_params)
      render template: 'check_points/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_points/1
  # PATCH/PUT /check_points/1.json
  def update
    respond_to do |format|
      if @check_point.update(check_point_params)
        format.html { redirect_to @check_point, notice: 'Check Point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @check_point.errors, status: :internal_server_error }
      end
    end

  end

  # DELETE /check_points/1
  # DELETE /check_points/1.json
  def destroy
    begin
      @check_point.destroy
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_point
      @check_point = CheckPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_point_params
      request_para = params[:check_point].nil? ? params : params[:check_point]
      request_para.select{|key,value| key.in?(CheckPoint.column_names())}.symbolize_keys
    end
end
