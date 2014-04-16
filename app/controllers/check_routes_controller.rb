class CheckRoutesController < ApplicationController
  before_action :set_check_route, only: [:show, :edit, :update, :destroy]

  # GET /check_routes
  # GET /check_routes.json
  def index

    @check_routes = CheckRoute.where(check_route_params)
    if params[:group_by_asset] == 'true'
      @route_assets = Hash.new
      @check_routes.each do |route|
        assets = Hash.new
        route.check_points.each do |point|

           if assets[point.asset.id].nil?
             assets[point.asset.id] = Set.new
           end
           assets[point.asset.id].add(point.id)
        end
        @route_assets[route.id] = assets
      end
    else
      @route_assets = nil
    end
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

  def new
    @check_route = CheckRoute.new
  end


  # PATCH/PUT /check_routes/1
  # PATCH/PUT /check_routes/1.json
  def update

      respond_to do |format|
        if @check_route.update(check_route_params)
          format.html { redirect_to @check_route, notice: 'Check Route was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @check_route.errors, status: :internal_server_error }
        end
      end
   end

  # DELETE /check_routes/1
  # DELETE /check_routes/1.json

  def destroy
    respond_to do |format|
      if @check_route.destroy
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
    def set_check_route
      @check_route = CheckRoute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_route_params
      request_para = params[:check_route].nil? ? params : params[:check_route]
      request_para.select{|key,value| key.in?(CheckRoute.column_names())}.symbolize_keys
    end
end
