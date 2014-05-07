module UserPreferencesHelper

  def get_preferences(paras)
    #TODO: if not signed in we should really just return []
    if user_signed_in?
      paras[:user_id] = current_user.id
    end
    UserPreference.where(paras)
  end
end
