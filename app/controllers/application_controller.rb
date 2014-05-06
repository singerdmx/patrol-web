class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  #before_action :authenticate,     only: [:index, :new, :show, :edit, :update, :destroy]
  #TODO: use cancan to do authorization (e.g., user cannot create routes etc)
  protected
    def authenticate
      respond_to do |format|
        format.json {
            render json: {:message=> 'Action not allowed for this user'}.to_json, status: :unauthorized if !user_signed_in?  && !admin_signed_in?
        }
        format.html{ authenticate_user! }
      end

    end


end
