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

  def rdio_user
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
 
  def playlist
    if current_user
      
      #verifying the user with rdio_user method
      rdio_user
      
      #now we make a request to rdio with the new object and with rdio's api's  getPlaylist method including extras => tracks                          
      @tracks = @rdio.call('getPlaylists', "extras" => "tracks")["result"]["owned"]
    end
  end
  
  def new_playlist
    @playlist = Playlist.new
  end
  
  def create_playlist 
    if current_user
      rdio_user
      
      #@new_playlist = rdio.call('createPlaylist','name' => @playlist_name,'description' => @playlist_description,'tracks' => @track_keys)
        
    end
  end

end
