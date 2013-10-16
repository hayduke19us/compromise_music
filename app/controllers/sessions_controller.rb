class SessionsController < ApplicationController
  
  def index
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

  def playlist
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
      rdio = Rdio::SimpleRdio.new([Figaro.env.omniauth_consumer_key, Figaro.env.omniauth_consumer_secret],
                                    [@token, @secret])
                                    
      #now we make request to rdio with the new object and with rdio's api's methods                          
       @tracks = rdio.call('getPlaylists', "extras" => "tracks")["result"]["owned"]
       
      #@new_playlist = rdio.call('createPlaylist','name' => 'create_playlist_test','description' => 'a_test_created_playlist','tracks' => 't35335073')
        
    end
  end
end
