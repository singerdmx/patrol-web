class StaticPagesController < ApplicationController

  def home
    redirect_to new_user_session_path unless user_signed_in?

    #redirect_to "/users/#{current_user.email}"
  end

  def help
  end

  def about
  end

  def contact
  end
end
