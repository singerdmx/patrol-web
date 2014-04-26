class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      redirect_to "/users/#{current_user.id}"
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
