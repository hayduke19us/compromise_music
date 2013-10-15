class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
<<<<<<< HEAD
  def user_params
    params.require(:playlist).permit(:name, :description, :user_id)
  
  end  

=======
    
    private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
    end
    helper_method :current_user
    
  
  
>>>>>>> cbdef9db19fd030a10f80b2a1182e898ec1c5680
end
