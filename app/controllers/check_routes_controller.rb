class CheckRoutesController < ApplicationController
  before_action :set_check_route, only: [:show, :edit, :update, :destroy]

  # GET /check_routes
  # GET /check_routes.json
  def index
    @check_routes = CheckRoute.where(check_route_params)
    if stale?(etag: @check_routes.to_a,
              last_modified: @check_routes.maximum(:updated_at))
      render template: 'check_routes/index', status: :ok
    else
      head :not_modified
    end
  end

  # GET /check_routes/1
  # GET /check_routes/1.json
  def show
    begin
      render template: 'check_routes/show',  status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end

  # POST /check_routes
  # POST /check_routes.json
  def create
    begin
      @check_route = CheckRoute.create!(check_route_params)
      render template: 'check_routes/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /check_routes/1
  # PATCH/PUT /check_routes/1.json
  def update
    begin
      @check_route.update(check_route_params)
      #TODO dedup
      @check_route.assets<< Asset.find(params[:asset_id])  if (!params[:asset_id].nil?)
      render template: 'check_routes/show', status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # DELETE /check_routes/1
  # DELETE /check_routes/1.json

  def destroy
    begin
      @check_route.destroy
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_route
      @check_route = CheckRoute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_route_params
      params.select{|key,value| key.in?(CheckRoute.column_names())}
    end
end
