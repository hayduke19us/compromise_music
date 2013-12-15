class TracksController < ApplicationController
   before_filter :get_rdio_user
    
   def create
    playlist = Playlist.find(params[:playlist_id])
    if params[:group]
      group = Group.find(params[:group_id])
    end
    all_tracks = playlist.tracks.count
    index = index_create(all_tracks) 
    rdio_track = RdioTrack.track_attributes(params[:track]) 
    my_track = {playlist_id: playlist.id, 
                index: index, 
                playlist_key: playlist.key,
                user_id: current_user.id}
    track_params = rdio_track.merge(my_track)    
    RdioTrack.add_track(playlist.key, rdio_track[:key])
    
    track = Track.new(track_params) 
    if track.save
      flash[:notice] = "#{track.name} added to playlist"
      unless params[:group]
        redirect_to user_playlist_path(playlist.user_id, 
                                       playlist.id)
      else
        redirect_to user_playlist_path(path.user_id,
                                      playlist.id,
                                      group: group.id)
      end
    else
      flash[:notice] = "Something went wrong"
      redirect_to user_playlist_path(playlist.user_id, playlist.id)
    end
    
  end
  
  def destroy
    if params[:group]
      group = Group.find(params[:group])
    end
    track = Track.find(params[:id])
    playlist = Playlist.find(track.playlist_id)
    if track.destroy
     index_destroy(playlist, track) 
    end   
    RdioTrack.remove_track(track.playlist_key,track.index, track.key)
    unless params[:group]
      redirect_to user_playlist_path(playlist.user_id, playlist.id)
    else
      redirect_to user_playlist_path(playlist.user_id, playlist.id, group: group.id)
    end
  end
  
  def vote_up
   @user = User.find(params[:current_user])
   track = Track.find(params[:id])
   unless @user.voted_for?(track)
     @user.vote_exclusively_for(track)
     flash[:notice] = "#{track.name} voted up"  
     redirect_to user_playlist_path(params[:playlists_owner], params[:playlist_id])
   else
     flash[:notice] = "#{track.name} already voted for"  
     redirect_to user_playlist_path(params[:playlists_owner], params[:playlist_id])
   end
  end
  
  def vote_down
    @user = User.find(params[:current_user])
    track = Track.find(params[:id])
    unless @user.voted_against?(track)
      @user.vote_exclusively_against(track)
      flash[:notice] = "#{track.name} voted down"  
      redirect_to user_playlist_path(params[:playlist_owner], 
                                       params[:playlist_id])
    else
       flash[:notice] = "#{track.name} already voted down"  
       redirect_to user_playlist_path(params[:playlist_owner], 
                                        params[:playlist_id])
    end
  end
  
    private
    def index_create(track_count)
      if track_count == 0
        @index = 1
      elsif track_count >= 1
        @index = track_count + 1
      end
    end 


    def index_destroy(ch_play, d_track)
      ch_play.tracks.each do |t|
        unless t.index <= d_track.index
          index = t.index
          t.index = (index - 1)
          t.save
        end
      end
    end

end
