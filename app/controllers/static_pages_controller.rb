class StaticPagesController < ApplicationController

  def home
    self.request.env.each do |header|
      logger.debug "HEADER KEY: #{header[0]}"
      logger.debug "HEADER VAL: #{header[1]}"
    end

    respond_to do |format|
      if user_signed_in?
        logger.debug("logged in")
        format.html { redirect_to "/users/#{current_user.id}" }
        format.json { render json: { result: 'success' }.to_json, status: :ok }
      else
        logger.debug("failed to log in")
        format.html { render :home, :status => :unauthorized }
        format.json { render json: { error: '密码错误' }.to_json, status: :unauthorized }
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
