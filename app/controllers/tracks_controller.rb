class TracksController < ApplicationController
  before_filter :get_rdio_user

  def create
    playlist = Playlist.find(params[:playlist_id])
    track_count = playlist.tracks.count
    if track_count == 0
      @index = 1
    elsif track_count >= 1
      @index = track_count + 1
    end
    add_to_playlist = @rdio.call('addToPlaylist', 'playlist' => "#{params[:playlist_key]}", 'tracks' => "#{params[:key]}")
    @track = Track.new
    @track.name = params[:name]
    @track.key = params[:key]
    @track.playlist_id = params[:playlist_id]
    @track.embedUrl = params[:embedUrl]
    @track.playlist_key = params[:playlist_key]
    @track.index = @index
    
    if @track.save
      flash[:notice] = "#{@track.name} added to playlist"
      redirect_to(:controller => "playlists", :action => "show", :id => params[:playlist_id])
    else
      flash[:notice] = "Something went wrong"
      redirect_to(:controller => "playlists", :action => "show", :id => params[:playlist_id])
    end
    
  end
  
  def destroy
    all_tracks = Track.all
    track = Track.find(params[:id])
    playlist = Playlist.find(track.playlist_id)
  
    if track.destroy
      all_tracks.each do |t|
        unless t.index <= track.index
         index = t.index
         t.index = (index - 1)
         t.save
        end
      end
    end   
      
    
    remove_from_playlist = @rdio.call('removeFromPlaylist', 'playlist' => "#{track.playlist_key}", 'index' =>"#{track.index}",
                                      'count' => '1', 'tracks' => "#{track.key}")
    redirect_to(:controller => "playlists", :action => "show", :id => track.playlist_id)
  end
  
 
end
