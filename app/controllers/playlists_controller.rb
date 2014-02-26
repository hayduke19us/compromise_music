class PlaylistsController < ApplicationController

  before_filter :get_rdio_user, only: [:create, :search_helper, :publish, 
                                       :destroy, :search_result]

  respond_to :js, :html

  def index
    @playlists = current_user.playlists
    respond_with @playlists
  end

  def new
    @playlists = Playlist.all
  end

  def create
    unless params[:name].blank? || params[:description].blank?
      RdioPlaylist.new_playlist(params[:name], params[:description])
      playlist_params = RdioPlaylist.playlist_attributes(current_user.id)
      playlist = Playlist.new(playlist_params)
      if playlist.save
        if params[:tags]
          tags = params[:tags].split(',')
          tracks = Tag.users_tracks(playlist.user, tags.flatten)
          tracks.each do |track|
            @tagged = playlist.tag_compilation track
            new_track = Track.find(@tagged)
            sync_new new_track, scope: playlist 
          end
        end
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
=begin
  def tag_created_playlist tracks, playlist
    unless tracks.empty?
      tracks.each do |track|
        index = playlist.next_index
        @new_track = Track.new(name: track.name,
                               key:  track.key,
                               embedUrl: track.embedUrl,
                               playlist_id: playlist.id,
                               index: index,
                               user_id: playlist.user_id,
                               album: track.album,
                               artist: track.artist,
                               album_key: track.album_key,
                               playlist_key: playlist.key)
        if @new_track.save
          RdioTrack.add_track playlist.key, @new_track.key
          sync_new @new_track, scope: playlist
          @new_track.index_after
          playlist.sort_for_rdio
        end
      end
    end
  end
=end

  def search_result
    respond_with search_helper
  end

  def show
  end

  def search_helper
    if params[:query]
      rdio_search =  RdioSearch.new(search_type: params[:search_type],
                                      query: params[:query])
      @search_results = rdio_search.simple
    elsif params[:artist_key_tracks] 
      @search_results = RdioSearch.new(
        artist_key: params[:artist_key_tracks]).artist_tracks(
        params[:artist_query])
    elsif params[:list]
      @album_tracks = RdioSearch.new(list: params[:list]).album_tracks
    elsif params[:artist_key]
      rdio_search = RdioSearch.new(artist_key: params[:artist_key])
      @search_results = rdio_search.artist_albums
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
    playlist.sort_for_rdio

    #voting game begins
    game = playlist.game

    async = game.simple_success

    unless async == nil
      async.each do |track|
        sync_destroy track
        track.destroy
      end
    end
    @playlist = playlist
    respond_with @playlist
  end

end
