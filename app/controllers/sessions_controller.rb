class SessionsController < ApplicationController
  RDIO_KEY = Figaro.env.omniauth_consumer_key
  RDIO_SECRET = Figaro.env.omniauth_consumer_secret
  
  def index
    if current_user
     
    end
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
   RDIO_KEY = 'vc76wjg3xyyqawc7m7dttjmq'
   RDIO_SECRET = 'NxMYesjNWW'
  def playlist
     
    if current_user
       @token = current_user.access_token.to_s
       @secret = current_user.access_secret.to_s
      
        #for browsing the info
        filename = '.access_token.yaml'
          File.open filename, 'w' do |f|
            f.write "ACCESS_TOKEN  #{@token}"
            puts 
            f.write "ACCESS_SECRET  #{@secret}" 
            f.close
          end

        rdio = Rdio::SimpleRdio.new([Figaro.env.omniauth_consumer_key, Figaro.env.omniauth_consumer_secret],
                                    [@token, @secret])
        playlist = rdio.call('getPlaylists')['result']['owned']
        tracks = rdio.call('getPlaylists', "extras" => "tracks")["result"]["owned"]
        HH
        @playlists = playlist
        @tracks = tracks
        
      
      
    
    end
  end

    

end
