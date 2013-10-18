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
 
  def new_playlist
    @playlist = Playlist.new
    
  end
  
  def create_playlist 
    name = params[:name]
    description = params[:description]
    playlist = @rdio.call('createPlaylist','name' => "#{name}",'description' => "#{description}",'tracks' => 't35335083', 'collaborationMode' => '1')
    redirect_to playlists_index_path
  end
  
  def search_for_stuff
    user_query = params[:query]
    user_type = params[:type]
    @search_result = @rdio.call('search','query' => "#{user_query}", 'types' => "#{user_type}")["result"]["results"]
    redirect_to playlists_index_path
  end
end

