class PlaylistsController < ApplicationController
  #verifying the user with rdio_user method
  before_filter :get_rdio_user
  
  def index
    @friend_view = params[:friend_view]
    if params[:query] && params[:type] 
      @search_result = @rdio.call('search','query' => "#{params[:query]}", 'types' => "#{params[:type]}")["result"]["results"]
      redirect_to(:controller => 'playlists', :action => "show", :id => params[:playlist_id])
    end
  end
   
  def new
  end
  
  def create
    if params[:name].blank? || params[:description].blank?
      flash[:notice] = "A playlist must have a name and a description"
      redirect_to new_playlist_path
    else
      @playlist = Playlist.new(params[:playlist])
      rdio_playlist = @rdio.call('createPlaylist','name' => "#{params[:name]}",'description' => "#{params[:description]}",'tracks' => 't35335083', 'collaborationMode' => '1')
      @playlist.name = rdio_playlist['result']['name']
      @playlist.description = params[:description]
      @playlist.embedUrl = rdio_playlist['result']['embedUrl']
      @playlist.key = rdio_playlist['result']['key']
      @playlist.user_id = current_user.id
        if @playlist.save
          flash[:notice] = "You have succesfully created a Playlist"  
           redirect_to action: :show, id: @playlist.id
        else
          flash[:notice] = "You were unable to save a Playlist"
          redirect_to  new_playlist_path
        end
    end
  end

  def show
    @user = current_user
    @user_id = @user.id.to_i
    @playlist = Playlist.find(params[:id])
    @playlist_user_id = @playlist.user_id.to_i
    if params[:query]  
      @search_result = @rdio.call('search','extras' => 'embedUrl', 'query' => "#{params[:query]}", 'types' => "Tracks")["result"]["results"]
    end
  end
  
  def destroy
    playlist = Playlist.find(params[:id])
    @rdio.call('deletePlaylist', 'playlist' => "#{playlist.key}")
    if playlist.destroy
      flash[:notice] = "You have deleted #{playlist.name}"
      redirect_to root_path 
    end
  end
  
  def rdio_playlist
     if current_user
       #now we make a request to rdio with the new object and with rdio's api's  getPlaylist method including extras => tracks                          
       @tracks = @rdio.call('getPlaylists', "extras" => "tracks")['result']['owned']
     end
   end
  

end
