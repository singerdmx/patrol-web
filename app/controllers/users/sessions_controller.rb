class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json
  # POST /resource/sign_in
  def create
    super
  end

end