class PlaylistsController < ApplicationController
  before_filter :get_rdio_user 
  extend VotingGame
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
      playlist.save
      flash[:notice] = "You have succesfully created a Playlist"
      redirect_to root_path 
    else
        flash[:notice] = "A playlist requires a name and description"
        redirect_to root_path
    end
  end
  
  def total_votes tracks
    x = 0 
    tracks.each {|track| x += track.votes_for - track.votes_against}
    x
  end

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
    grouplists = playlist.grouplists
    playlist.sort_for_rdio

    #voting game begins

    game = VotingGame::Playlist.new attributes: playlist,
                                    grouplists: grouplists,
                                    point_adjuster: VotingGame::SuccessFilter.new
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
