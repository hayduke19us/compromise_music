class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
  def user_params
    params.require(:playlist).permit(:name, :description, :user_id)
  
  end  

end
