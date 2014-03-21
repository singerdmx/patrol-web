class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  # GET /assets
  # GET /assets.json
  def index
    begin

      @assets = Asset.where(asset_params)
      if stale?(etag: @assets.to_a,
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
    begin
      @asset.update(asset_params)
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    begin
      @asset.destroy
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.select{|key,value| key.in?(Asset.column_names())}
    end
end
