class PlaylistsController < ApplicationController
  #verifying the user with rdio_user method
  before_filter :get_rdio_user
  
  def index
    if params[:query] && params[:type] 
      @search_result = @rdio.call('search','query' => "#{params[:query]}", 'types' => "#{params[:type]}")["result"]["results"]
    end
  end
  
  def playlist
    if current_user
      #now we make a request to rdio with the new object and with rdio's api's  getPlaylist method including extras => tracks                          
      @tracks = @rdio.call('getPlaylists', "extras" => "tracks")['result']['owned']
    end
  end
 
  def new
    
  end
  
  def create_playlist 
    @playlist = Playlist.new
    name = params[:name]
    description = params[:description]
    playlist = @rdio.call('createPlaylist','name' => "#{name}",'description' => "#{description}",'tracks' => 't35335083', 'collaborationMode' => '1')
    @playlist.name = playlist['result']['name']
    @playlist.description = description
    @playlist.embedUrl = playlist['result']['embedUrl']
    @playlist.key = playlist['result']['key']
    @playlist.user_id = current_user.id
    if @playlist.save
      flash[:notice] = "You have succesfully created a Playlist"  
      redirect_to '/playlists/add_songs_to_playlist'
    else
      flash[:notice] = "You were unable to save a Playlist"
      redirect_to new_playlist_path
    end
  
      
     
  end

  def add_songs_to_playlist
    @new_playlist = current_user.playlists.last
    
    
  end
end

