class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def get_rdio_user
    if current_user
      @token = current_user.access_token.to_s
      @secret = current_user.access_secret.to_s
      
      #for browsing the info
      filename = '.access_token.yaml'
        File.open filename, 'w' do |f|
          f.write "ACCESS_TOKEN....  #{@token}"
          puts 
          f.write "ACCESS_SECRET....  #{@secret}"
          f.close
        end
          
      #we first create a rdio object with current users info
      @rdio = Rdio::SimpleRdio.new([Figaro.env.omniauth_consumer_key, Figaro.env.omniauth_consumer_secret],
                                    [@token, @secret])
    end
  end
  @full_name = name = []
end
