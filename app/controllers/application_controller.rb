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
    if params[:controller] == 'static_pages'
      flash.delete(:success)
      flash.delete(:error)
      case params[:action]
        when 'reset_password'
          render template: 'users/passwords/reset'
          return
        when 'generate_new_password_email'
          email = params[:user][:email]
          user = User.find_by_email(email)
          if user
            user.send_reset_password_instructions
            flash[:success] = "已经发送邮件到#{email}"
          else
            flash[:error] = "无法找到邮箱是#{email}的用户"
          end
          render template: 'users/passwords/reset'
          return
      end
    end

    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

  def convert_check_time(params)
    unless params[:check_time].nil?
      unless params[:check_time].include?('..') && params[:check_time].split('..').size == 2
        fail "Invalid check_time param #{params[:check_time]}"
      end

      time_window = params[:check_time].split('..')
      params[:check_time] = Time.at(time_window[0].to_i).to_datetime..Time.at(time_window[1].to_i).to_datetime
    end

    params
  end

end
