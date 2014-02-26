class TracksController < ApplicationController
  respond_to :js, :html 
  before_filter :get_rdio_user

   def create
     playlist = Playlist.find(params[:playlist_id])
     index = playlist.next_index
     rdio_track = RdioTrack.track_attributes(params[:track])
     my_track = {playlist_id: playlist.id,
                 index: index,
                 playlist_key: playlist.key,
                 user_id: current_user.id}
     track_params = rdio_track.merge my_track
     track = Track.new track_params

     if track.save
       RdioTrack.add_track playlist.key, rdio_track[:key]
       sync_new track, scope: playlist
       sync_update playlist
       track.index_after
       playlist.sort_for_rdio
       respond_with 
     end
   end

  def destroy
    track = Track.find(params[:id])
    playlist = Playlist.find(track.playlist_id)
    if track.destroy
      track.destroy_with_rdio
      sync_destroy track
      sync_update playlist.reload
      playlist.sort_for_rdio
      respond_with 
    end
  end

  def vote_up
   track = Track.find(params[:id])
   track.vote_up current_user
   track.index_after
   playlist = Playlist.find track.playlist_id
   sync_update track
   sync_update playlist
   playlist.sort_for_rdio
   respond_to do |format|
     format.html {redirect_to playlist_path(track.playlist_id)}
     format.js {head :no_content}
   end
  end

  def vote_down
    track = Track.find(params[:id])
    playlist = Playlist.find track.playlist_id
    track.vote_down current_user
    track.index_after
    sync_update track
    sync_update playlist
    playlist.sort_for_rdio
    respond_to do |format|
      format.html {redirect_to playlist_path(track.playlist_id)}
      format.js {head :no_content}
    end
  end

end
