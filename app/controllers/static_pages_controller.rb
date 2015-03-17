class StaticPagesController < ActionController::Base

  def home
    self.request.env.each do |header|
      logger.debug "HEADER KEY: #{header[0]}"
      logger.debug "HEADER VAL: #{header[1]}"
    end

    respond_to do |format|
      if user_signed_in?
        logger.debug("logged in")
        if current_user.patrol_user?
            format.html { redirect_to "/users/#{current_user.id}" }
        elsif current_user.repair_user?
            format.html { redirect_to "/repair_users/#{current_user.id}" }
        else
          format.html { render :home, status: :internal_server_error }
          format.json { render json: { error: '用户类型错误' }.to_json, status: :internal_server_error }
          return
        end

        format.json { render json: { result: 'success' }.to_json, status: :ok }
      else
        logger.debug("failed to log in")
        format.html { redirect_to "/users/sign_in"}
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

  def generate_new_password_email
    email = params[:email]
    user = User.find_by_email(email)

    if user
      user.send_reset_password_instructions
      @message = "Reset email instruction sent to #{email}."
    else
      @message = "Cannot find the user email #{email}."
    end
  end

  def reset_password
    unless user_signed_in?
      render :reset_password
    end
  end

end
