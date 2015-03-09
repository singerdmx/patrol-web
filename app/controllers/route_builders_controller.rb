class RouteBuildersController < ApplicationController
  before_action :set_route_builder, only: [:show, :edit, :update, :destroy]

  # GET /route_builders
  # GET /route_builders.json
  def index
    @route_builders = RouteBuilder.where(route_builder_params)
    if stale?(etag: @route_builders.to_a,
              last_modified: @route_builders.maximum(:updated_at))
      render template: 'route_builders/index', status: :ok
    else
      head :not_modified
    end
  end

  # GET /route_builders/1
  # GET /route_builders/1.json
  def show
    render template: 'route_builders/show',  status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  # GET /route_builders/new
  def new
    @route_builder = RouteBuilder.new
  end

  # GET /route_builders/1/edit
  def edit
  end

  # POST /route_builders
  # POST /route_builders.json
  def create
    begin
      @route_builder = RouteBuilder.create!(route_builder_params)
      render template: 'route_builders/show', status: :created
    rescue Exception => e
      Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
      render json: {message: e.to_s}.to_json, status: :internal_server_error
    end

  end

  # PATCH/PUT /route_builders/1
  # PATCH/PUT /route_builders/1.json
  def update
    respond_to do |format|
      if @route_builder.update(route_builder_params)
        format.html { redirect_to @route_builder, notice: 'Route builder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @route_builder.errors, status: :internal_server_error }
      end
    end

  end

  # DELETE /route_builders/1
  # DELETE /route_builders/1.json
  def destroy

    respond_to do |format|
      if @route_builder.destroy
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
    def set_route_builder
      @route_builder = RouteBuilder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def route_builder_params
      request_para = params[:route_builder].nil? ? params : params[:route_builder]
      request_para.select{|key,value| key.in?(RouteBuilder.column_names())}.symbolize_keys
    end
end
