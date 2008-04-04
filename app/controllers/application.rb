# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_myvocab_session_id'

  def check_authentication
    redirect_to login_url unless session[:user]
  end

  def current_user_id
    session[:user]
  end

  def get_from_lang
    session[:from_lang].nil? ? 'en' : session[:from_lang]
  end

  def get_to_lang
    session[:to_lang].nil? ? 'hu' : session[:to_lang]
  end

end
