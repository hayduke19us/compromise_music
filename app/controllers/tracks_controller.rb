class TracksController < ApplicationController
   before_filter :get_rdio_user
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
    @track = Track.new(track_params)
    if @track.save
      sync_new @track, scope: @playlist
      respond_to do |format|
        format.html {redirect_to playlist_path(@path)}
        format.js {head :no_content}
      end
    end

  end

  def destroy
    if params[:group]
        @group = Group.find(params[:group])
    end
    @track = Track.find(params[:id])
    @playlist = Playlist.find(@track.playlist_id)
    if @track.destroy
      @track.destroy_with_rdio(1)
      sync_destroy @track
      respond_to do |format|
        format.html {redirect_to playlist_path(@playlist)}
        format.js {head :no_content}
      end
    end
  end

  def vote_up
   @playlist = Playlist.find(params["playlist_id"])
   @track = Track.find(params[:id])
   current_user.vote_for(@track)
   sync_update @track
   respond_to do |format|
     format.html {redirect_to playlist_path(@playlist)}
     format.js {head :no_content}
   end
  end

  def vote_down
    @playlist =Playlist.find(params["playlist_id"])
    @track = Track.find(params[:id])
    current_user.vote_against(@track)
    sync_update @track
    respond_to do |format|
      format.html {redirect_to playlist_path(@playlist)}
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
