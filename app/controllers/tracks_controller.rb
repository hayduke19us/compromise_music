class TracksController < ApplicationController
  before_filter :get_rdio_user
  
  def new
    @track = Track.new
    create
  end 
    
  def create
    playlist = Playlist.find(params[:playlist_id])
    track_count = playlist.tracks.count
    if track_count == 0
      @index = 1
    elsif track_count >= 1
      @index = track_count + 1
    end
    track = @rdio.call('addToPlaylist', 'playlist' => "#{params[:playlist_key]}", 'tracks' => "#{params[:key]}")
    @track.name = params[:name]
    @track.key = params[:key]
    @track.embedUrl = params[:embedUrl]
    @track.playlist_key = params[:playlist_key]
    @track.playlist_id = params[:playlist_id]
    @track.index = @index
    if @track.save
      flash[:notice] = "#{@track.name} added to playlist"
      redirect_to user_playlist_path(params[:user_id], params[:playlist_id])
    else
      flash[:notice] = "Something went wrong"
      redirect_to user_playlist_path(params[:user_id], params[:playlist_id])
    end
    
  end
  
  def destroy
    track = Track.find(params[:id])
    playlist = Playlist.find(track.playlist_id)
    if track.destroy
      playlist.tracks.each do |t|
        unless t.index <= track.index
         index = t.index
         t.index = (index - 1)
         t.save
        end
      end
    end   
    @rdio.call('removeFromPlaylist', 'playlist' => "#{track.playlist_key}", 'index' =>"#{track.index}",
                                     'count' => '1', 'tracks' => "#{track.key}")
    redirect_to user_playlist_path(playlist.user_id, playlist.id)
  end
  
  def vote_up
     @user = current_user
     track = Track.find(params[:id])
     unless @user.voted_for?(track)
     @user.vote_exclusively_for(track)
     flash[:notice] = "#{track.name} voted up"  
     redirect_to friend_playlist_path(params[:user_id], params[:playlist_id])
     else
       flash[:notice] = "#{track.name} already voted for"  
       redirect_to friend_playlist_path(params[:user_id], params[:playlist_id])
     end
  end
  
  def vote_down
    @user = current_user
    track = Track.find(params[:id])
    unless @user.voted_against?(track)
      @user.vote_exclusively_against(track)
      flash[:notice] = "#{track.name} voted down"  
      redirect_to friend_playlist_path(params[:user_id], params[:playlist_id])
    else
       flash[:notice] = "#{track.name} already voted down"  
       redirect_to friend_playlist_path(params[:user_id], params[:playlist_id])
    end
  end
end
