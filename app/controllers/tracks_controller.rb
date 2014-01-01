class TracksController < ApplicationController
   before_filter :get_rdio_user

   def create
     playlist = Playlist.find(params[:playlist_id])
     all_tracks = playlist.tracks.count
     index = index_create all_tracks
     rdio_track = RdioTrack.track_attributes(params[:track])
     my_track = {playlist_id: playlist.id,
                 index: index,
                 playlist_key: playlist.key,
                 user_id: current_user.id}
     track_params = rdio_track.merge my_track
     RdioTrack.add_track playlist.key, rdio_track[:key]
     track = Track.new track_params
     if track.save
       sync_new track, scope: playlist
       respond_to do |format|
         format.html {redirect_to playlist_path(playlist.id)}
         format.js {head :no_content}
       end
     end
   end

  def destroy
    track = Track.find(params[:id])
    playlist = Playlist.find(track.playlist_id)
    if track.destroy
      track.destroy_with_rdio 
      sync_destroy track
      respond_to do |format|
        format.html {redirect_to playlist_path(playlist)}
        format.js {head :no_content}
      end
    end
  end

  def vote_up
   track = Track.find(params[:id])
   track.vote_up current_user
   playlist = Playlist.find track.playlist_id
   sorted_playlist = playlist.tracks.sort_by {|t| t.votes_for - t.votes_against}
   x = 0
   sorted_playlist.reverse.each do |track|
     track.index = x
     track.save
     sync_update track
     x += 1
   end
   respond_to do |format|
     format.html {redirect_to playlist_path(track.playlist_id)}
     format.js {head :no_content}
   end
  end

  def vote_down
    track = Track.find(params[:id])
    track.vote_down current_user
    sync_update track
    respond_to do |format|
      format.html {redirect_to playlist_path(track.playlist_id)}
      format.js {head :no_content}
    end
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
