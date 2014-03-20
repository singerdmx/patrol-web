class CheckPointsController < ApplicationController
  before_action :set_check_point, only: [:show, :edit, :update, :destroy]

  # GET /check_points
  # GET /check_points.json
  def index
    asset = Asset.find(params[:asset_id])
    @check_points = asset.check_points.where(check_point_params)
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



  # POST /check_points
  # POST /check_points.json
  def create
    begin
      asset = Asset.find(params[:asset_id])
      @check_point = asset.check_points.create!(check_point_params)
      render template: 'check_points/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_points/1
  # PATCH/PUT /check_points/1.json
  def update
      begin
        @check_point.update(check_point_params)
      rescue Exception => e
        render json: {:message=> e.to_s}.to_json, status: :internal_server_error
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
      params.select{|key,value| key.in?(CheckPoint.column_names())}
    end
end
