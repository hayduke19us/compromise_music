class PlaylistsController < ApplicationController
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
    if params[:query]  
      @search_result = RdioTrack.search_by_track(params[:query])
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
    playlist.tracks.each do |track|
      unless track.votes_for >= 1
        track.destroy
      end
    end
    redirect_to user_playlist_path(playlist.user_id, playlist.id)
  end
end
