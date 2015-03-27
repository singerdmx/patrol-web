class UsersController < ApplicationController
  include UsersHelper

  def show
    @show_full_view = show_full_view?
  end

  # GET /users.json
  def index
    ActiveRecord::Base.transaction do
      users = User.where(tombstone: false)
      users_index_json = to_json(users)
      users_index_json = index_ui_json_builder(users_index_json) if params[:ui] == 'true'
      if stale?(etag: users_index_json,
                last_modified: users.maximum(:updated_at))
        render json: users_index_json.to_json, status: :ok
      else
        head :not_modified
      end
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :not_found
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:success] = '更新成功！请重新登录。'
    else
      flash[:error] = '更新失败！'
    end

    render 'edit'
  end

  # POST /users
  # POST /users.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      user = User.find_by_email(params[:email])
      unless user.nil?
        render json: {message: "用户 #{params[:email]} 已经存在！"}.to_json, status: :unprocessable_entity
        return
      end

      User.create! do |u|
        u.email = params[:email]
        u.password = params[:password]
        u.role = params[:role]
        u.name = params[:name]
      end
    end

    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      User.find(params[:id]).update_attributes(tombstone: true)
      UserPreference.where(user_id: params[:id]).delete_all
    end
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  # GET /users/#{id}/routes
  def routes
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      curr_routes = CheckRoute.joins(:users).where("users.id = #{params[:user_id]}")
      rest_routes = CheckRoute.all - curr_routes
      routes_json = { curr_routes: routes_to_json(curr_routes),
                       rest_routes: routes_to_json(rest_routes) }

      render json: routes_json, status: :ok
    end
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end

  # PUT /users/#{id}/set_routes
  def set_routes
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      user  = User.find(params[:user_id])
      if user.nil?
        render json: {message: "User #{params[:user_id]} not found"}.to_json, status: :bad_request
        return
      end

      user.check_routes.delete_all

      if params[:routes]
        params[:routes].each do |r|
          route = CheckRoute.find(r)
          user.check_routes << route if route
        end
      end
    end

    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
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

  def routes_to_json(routes)
    routes.map do |r|
      to_hash(r, false)
    end
  end
end
