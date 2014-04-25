class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      redirect_to "/users/#{current_user.id}"
    else
      redirect_to new_user_session_path
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
