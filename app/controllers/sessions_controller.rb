class SessionsController < ApplicationController
  def index
    if current_user
      @token = current_user.access_token.to_s
      @secret = current_user.access_secret.to_s
      
      #for browsing the info
      filename = '.access_token.yml'
        File.open filename, 'w' do |f|
          f.write @token
          f.write @secret
          f.close
        end
    end
    rdio = Rdio::SimpleRdio.new([Figaro.env.omniauth_consumer_key, Figaro.env.omniauth_consumer_secret],
                                [@token, @secret])
                             
    #calls to rdio --->
      @playlist = rdio.call('getPlaylists')['result']['owned']                 
  end
  
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

    

end
