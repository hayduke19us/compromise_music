class TracksController < ApplicationController
   before_filter :get_rdio_user
   respond_to :html, :js 
    
   def create
    @playlist = Playlist.find(params[:playlist_id])
    all_tracks = @playlist.tracks.count
    index = index_create(all_tracks) 
    rdio_track = RdioTrack.track_attributes(params[:track]) 
    my_track = {playlist_id: @playlist.id, 
                index: index, 
                playlist_key: @playlist.key,
                user_id: current_user.id}
    track_params = rdio_track.merge(my_track)    
    RdioTrack.add_track(@playlist.key, rdio_track[:key])
    
    track = Track.new(track_params) 
    if track.save
      respond_with(@playlist, location: playlist_path(@playlist))
    end
    
  end
  
  def destroy
    if params[:group]
        @group = Group.find(params[:group])
    end
    track = Track.find(params[:id])
    @playlist = Playlist.find(track.playlist_id)
    if track.destroy
      track.destroy_with_rdio(1)
      respond_with(@playlist, location: playlist_path(@playlist))
    end
  end
  
  def vote_up
   @user = User.find(params[:current_user])
   @playlist = Playlist.find(params["playlist_id"])
   track = Track.find(params[:id])
   unless @user.voted_for?(track)
     @user.vote_exclusively_for(track)
     flash[:notice] = "#{track.name} voted up"  
   else
     flash[:notice] = "#{track.name} already voted for"  
   end
   respond_with @playlist, location: playlist_path(@playlist)
  end
  
  def vote_down
    @playlist =Playlist.find(params["playlist_id"])
    @user = User.find(params[:current_user])
    track = Track.find(params[:id])
    unless @user.voted_against?(track)
      @user.vote_exclusively_against(track)
      flash[:notice] = "#{track.name} voted down"  
    else
      flash[:notice] = "#{track.name} already voted down"  
    end
    respond_with @playlist, location: playlist_path(@playlist)
  end
  
    private
    def index_create(track_count)
      if track_count == 0
        @index = 0
      elsif track_count > 0 
        @index = track_count 
      end
    end 
end
