class UserPreferencesController < ApplicationController
  before_action :set_user_preference, only: [:show, :edit, :update, :destroy]
#  before_action :authenticate_admin!|| :authenticate_user!
  # GET /user_preferences
  # GET /user_preferences.json
  def index
    @user_preferences = UserPreference.where(user_preference_params)
    if stale?(etag: @user_preferences.to_a,
              last_modified: @user_preferences.maximum(:updated_at))
      render template: 'user_preferences/index', status: :ok
    else
      head :not_modified
    end
  end

  # GET /user_preferences/1
  # GET /user_preferences/1.json
  def show
    begin
      render template: 'user_preferences/show',  status: :ok
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end

  # GET /user_preferences/new
  def new
    @user_preference = UserPreference.new
  end

  # GET /user_preferences/1/edit
  def edit
  end

  # POST /user_preferences
  # POST /user_preferences.json
  def create

    begin
      @user_preference = UserPreference.create!(user_preference_params)
      render template: 'user_preferences/show', status: :created
    rescue Exception => e
      render json: {:message=> e.to_s}.to_json, status: :internal_server_error
    end
  end

  # PATCH/PUT /user_preferences/1
  # PATCH/PUT /user_preferences/1.json
  def update
    respond_to do |format|
      if @user_preference.update(user_preference_params)
        format.html { redirect_to @user_preference, notice: 'User preference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_preferences/1
  # DELETE /user_preferences/1.json
  def destroy
    respond_to do |format|
      if @user_preference.destroy
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
    def set_user_preference
      @user_preference = UserPreference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_preference_params
      params[:user_preference]
      request_para = params[:user_preference].nil? ? params : params[:user_preference]
      request_para.select{|key,value| key.in?(UserPreference.column_names())}.symbolize_keys
    end

end
