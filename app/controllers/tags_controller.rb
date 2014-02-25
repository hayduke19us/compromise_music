class TagsController < ApplicationController
  respond_to :js

  def create
    tag = Tag.new(name: params[:name],
                  taggable_id: params[:taggable_id],
                  taggable_type: params[:taggable_type])

    if params[:taggable_type] == 'Track'
      track = Track.find(params[:taggable_id].to_i)
      playlist = Playlist.find(track.playlist_id)
      if tag.save
        sync_update track
        @response = response_hash(playlist) 
        respond_with @response 
      else
        redirect_to root_url
      end
    elsif params[:taggable_type] == 'Playlist'
      playlist = Playlist.find(params[:taggable_id].to_i)
      if tag.save
        tag.tagged_playlist
        playlist.tracks.each { |track| sync_update track} 
        @response = response_hash(playlist) 
        respond_with @response 
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    track = tag.taggable
    playlist = Playlist.find(track.playlist_id)
    if tag.destroy
      sync_update track
      @response = response_hash(playlist)
      respond_with @response 
    else
      redirect_to root_url
    end
  end

    private

    def response_hash playlist
      sorted = playlist.sort_playlist
      {playlist: playlist, sorted: sorted}
    end
end
