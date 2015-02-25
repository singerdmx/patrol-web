class UserPreferencesController < ApplicationController
  include UserPreferencesHelper
#  before_action :authenticate_admin!|| :authenticate_user!
  # GET /user_preferences
  # GET /user_preferences.json
  def index
    ActiveRecord::Base.transaction do
      user_preferences = get_preferences(user_preference_params)
      if stale?(etag: user_preferences.to_a,
                last_modified: user_preferences.maximum(:updated_at))
        render json: user_preferences.to_json, status: :ok
      else
        head :not_modified
      end
    end
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  # POST /user_preferences
  # POST /user_preferences.json
  def create
    if !params.has_key?(:preferences)
      user_preference = UserPreference.create!(user_preference_params)
      render json: user_preference.to_json, status: :created
      return
    end

    params[:preferences] ||= []
    ActiveRecord::Base.transaction do
      old_points = current_user.preferred_points.map{|point| point.id}
      to_delete = old_points - params[:preferences]
      to_add =  params[:preferences] -  old_points
      UserPreference.where({user_id: current_user.id, check_point_id: to_delete}).delete_all
      to_add.each do |point_id|
        UserPreference.create!({user_id: current_user.id, check_point_id: point_id})
      end
    end
    render nothing: true, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_preference_params
      params[:user_preference]
      request_para = params[:user_preference].nil? ? params : params[:user_preference]
      request_para.select{|key,value| key.in?(UserPreference.column_names())}.symbolize_keys
    end

end
