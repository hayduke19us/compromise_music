class TagsController < ApplicationController
  respond_to :js

  def create
    track = Track.find(params[:taggable_id].to_i)
    tag = Tag.new(name: params[:name],
                  taggable_id: params[:taggable_id],
                  taggable_type: params[:taggable_type])
    playlist = Playlist.find(track.playlist_id)
    if tag.save
      tag.tagged_playlist
      sync_update track
      @response = response_hash(playlist) 
      respond_with @response 
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
