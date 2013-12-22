class PlaylistsController < ApplicationController
  before_filter :get_rdio_user 
  extend VotingGame
  respond_to :html, :js 
  def new
    @playlists = Playlist.all 
  end

  def create
    unless params[:name].blank? || params[:description].blank?
      RdioPlaylist.new_playlist(params[:name], params[:description])
      playlist_params = RdioPlaylist.playlist_attributes(current_user.id)
      playlist = Playlist.new(playlist_params)
      playlist.save
      flash[:notice] = "You have succesfully created a Playlist"
      redirect_to user_playlist_path(playlist.user_id, playlist.id)
    else
        flash[:notice] = "A playlist requires a name and description"
        redirect_to new_playlist_path
    end
  end

  def show
    @user = current_user
    @heavy_rotation = RdioUser.heavy_rotation(@user.key, 'true')
    @playlist = Playlist.find(params[:id])
    if params[:group]
      @group_id = params[:group]
    end
    unless params[:play_track].blank?
     @play_key = params[:play_track]
    end
    respond_with(search_helper, location:  playlist_path(@playlist))
    
  end

  def search_helper
    if params[:query]
      rdio_search =  RdioSearch.new(search_type: params[:search_type],
                                      query: params[:query])
      @search_results = rdio_search.simple
    elsif params[:list]
      @album_tracks = RdioSearch.new(list: params[:list]).album_tracks
    elsif params[:artist_key]
      rdio_search = RdioSearch.new(artist_key: params[:artist_key])
      @search_results = rdio_search.artist_albums
    end
  end

  def destroy
    playlist = Playlist.find(params[:id])
    RdioPlaylist.delete_playlist(playlist.key)
    playlist.destroy
    redirect_to root_url
  end

  def publish
    playlist = Playlist.find(params[:id])
    group = Group.find(params[:group])
    result =  VotingGame.track_success_filter(playlist,
                                              group,
                                              playlist.tracks.count)
    redirect_to playlist_path(playlist, group: group)
  end
end
