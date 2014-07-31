class UsersController < ApplicationController
  include UsersHelper

  def show
    @show_full_view = show_full_view?
  end

  # GET /users.json
  def index
    begin
      if show_full_view?
        @users = User.all
        @users_index_json = to_json(@users)
      end

      @users_index_json = index_ui_json_builder(@users_index_json) if params[:ui] == 'true'

      if stale?(etag: @users_index_json,
                last_modified: @users.maximum(:updated_at))
        render template: 'users/index', status: :ok
      else
        head :not_modified
      end
    rescue Exception => e
      Rails.logger.error("Encountered an error while indexing  #{e}")
      render json: {:message=> e.to_s}.to_json, status: :not_found
    end
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:success] = '更新成功！请重新登入。'
    else
      flash[:error] = '更新失败！'
    end

    render 'edit'
  end

  # POST /users
  # POST /users.json
  def create
    unless current_user.is_admin?
      render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    user = User.find_by_email(params[:email])
    unless user.nil?
      render json: {:message => "用户 #{params[:email]} 已经存在！"}.to_json, status: :unprocessable_entity
      return
    end

    User.create! do |u|
      u.email = params[:email]
      u.password = params[:password]
      u.role = params[:role]
      u.name = params[:name]
    end

    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error while creating user #{params.inspect}: #{e}")
    render json: {:message => e.to_s}.to_json, status: :unprocessable_entity
  end

  def destroy
    unless current_user.is_admin?
      render json: {:message => '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    User.find(params[:id]).destroy
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error while deleting user #{params.inspect}: #{e}")
    render json: {:message => e.to_s}.to_json, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def to_json(users)
    hash = []
    users.each do |u|
      hash << to_hash(u, false)
    end
    hash
  end
end
