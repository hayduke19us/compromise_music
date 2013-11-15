class PlaylistsController < ApplicationController
  before_filter :get_rdio_user
  def index
  end
    
  
  def new
  end
  
  def create
    unless params[:name].blank? || params[:description].blank?
      My_Rdio.new_playlist(params[:name], params[:description]) 
      playlist_params = My_Rdio.playlist_attributes(current_user.id)
      playlist = Playlist.new(playlist_params)
      playlist.save
      flash[:notice] = "You have succesfully created a Playlist"  
      redirect_to user_playlist_path(playlist.user_id, playlist.id)
    else
        flash[:notice] = "A playlist requires a name and description"
        render :new
    end
  end

  def show
    @user = current_user
    @playlist = Playlist.find(params[:id])
    if params[:query]  
      @search_result = My_Rdio.search_by_track(params[:query])
    end
  end
  
  def destroy
    playlist = Playlist.find(params[:id])
    My_Rdio.delete_playlist(playlist.key)
    playlist.destroy
    redirect_to root_url
  end

  def publish
    playlist = Playlist.find(params[:id])
    playlist.tracks.each do |track|
      unless track.votes_for >= 1
        track.delete
      end
    end
    redirect_to user_playlist_path(playlist.user_id, playlist.id)
  end
end
