module UserPreferencesHelper

  def get_preferences(paras)
    if user_signed_in?
      paras[:user_id] = current_user.id
      UserPreference.where(paras)
    else
      []
    end
  end
end
