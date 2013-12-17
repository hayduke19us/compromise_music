class ApplicationController < ActionController::Base
  include My_Rdio
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def get_rdio_user
      member = RdioUser.verify_user(current_user.access_token,
                                    current_user.access_secret) 
      RdioPlaylist.verified(member) 
      RdioTrack.verified(member) 
  end
end
