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

      if params[:ui] == 'true'
        @users_index_json = index_ui_json_builder(@users_index_json)
      end

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def to_json(users)
    hash = []
    users.each do |u|
      hash << to_hash(u, false)
    end
    hash
  end
end
