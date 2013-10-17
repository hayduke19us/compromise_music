class PlaylistsController < ApplicationController
  def index
    playlist
    
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
      @tracks = @rdio.call('getPlaylists', "extras" => "tracks")['result']['owned']
      @search_result = @rdio.call('search','query' => 'bob dylan Ramona', 'types' => "Track")["result"]["results"]
    end
  end
  
  
  
  def new_playlist
    @playlist = Playlist.new
    
  end
  
  def create_playlist 
    if current_user
      rdio_user
      name = params[:name]
      description = params[:description]
      playlist = @rdio.call('createPlaylist','name' => "#{name}",'description' => "#{description}",'tracks' => 't35335083', 'collaborationMode' => '1')
      redirect_to playlists_index_path
        
    end
  end
  
  
 
  

end
