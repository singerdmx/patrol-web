class UsersController < ApplicationController

  def show
    @show_full_view = current_user.is_admin? || current_user.is_leader?
  end
end
