class AssetsController < ApplicationController
  include AssetsHelper
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  #TODO: disable user role for CUD of assets
  # GET /assets
  # GET /assets.json
  def index
    begin

      @assets = Asset.where(asset_params)
      @assets_index_json =  index_json_builder(@assets)
      if stale?(etag: @assets_index_json,
                last_modified: @assets.maximum(:updated_at))
        render template: 'assets/index', status: :ok
      else
        head :not_modified
      end
    rescue Exception => e
      Rails.logger.error("Encountered an error while indexing  #{e}")
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end

  def edit
  end

  def new
    @asset = Asset.new
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    begin
      render template: 'assets/show',  status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end



  # POST /assets
  # POST /assets.json
  def create
    begin
      @asset = Asset.create!(asset_params)
      render template: 'assets/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset.errors, status: :internal_server_error }
      end
    end
   end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy

    respond_to do |format|
      if @asset.destroy
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
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      request_para = params[:asset].nil? ? params : params[:asset]
      request_para.select{|key,value| key.in?(Asset.column_names())}.symbolize_keys
    end
end
