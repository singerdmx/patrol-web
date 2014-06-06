class UsersController < ApplicationController
  include UsersHelper

  def show
    @show_full_view = current_user.is_admin? || current_user.is_leader?
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

  private

  def show_full_view?
    current_user.is_admin? || current_user.is_leader?
  end

  def to_json(users)
    hash = []
    users.each do |u|
      hash << to_hash(u, false)
    end
    hash
  end
end
