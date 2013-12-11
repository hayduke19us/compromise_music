class PlaylistsController < ApplicationController
  extend Voting_Game
  before_filter :get_rdio_user  
  
  def new
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
    @playlist = Playlist.find(params[:id])
    if params[:group]
      @group_id = params[:group]
    end
    unless params[:play_trck].blank?
     @play_key = params[:play_track]
    end
    if params[:query]  
      @search_result = RdioTrack.search_by_track(params[:search_type], 
                                                 params[:query])
    elsif params[:artist_key]
      @search_result = RdioTrack.albums_for_artist(params[:artist_key])
    elsif params[:list]
      if params[:list].class == Array
        @album_tracks = RdioTrack.get(params[:list].join(","))
      else
        album  = RdioTrack.get(params[:list])
        album = album.flatten
        @album_tracks = RdioTrack.get(album[1]['trackKeys'].join(","))
      end
      
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
    if Grouplist.where(group_id: group.id, 
                       playlist_id: playlist.id)
      @prizes = Voting_Game.track_success_filter(playlist, group)  
      redirect_to user_playlist_path(playlist.user_id, playlist.id, group: group.id)
    end
  end
end
