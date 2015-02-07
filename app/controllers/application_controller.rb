require_relative '../../app/config/settings'

class ApplicationController < ActionController::Base
  include RbConfig

  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  #before_action :authenticate,     only: [:index, :new, :create, :show, :edit, :update, :destroy]
  after_filter :set_csrf_header, only: [:new, :create]

  #rescue_from Exception do |e|
  #  render json: {:message=> e.to_s}.to_json, status: :internal_server_error
  #end

  protected

  def set_csrf_header
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  private

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

end
