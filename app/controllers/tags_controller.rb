class TagsController < ApplicationController
  respond_to :js
  
  def create
    track = Track.find(params[:taggable_id].to_i)
    tag = Tag.new(name: params[:name],
                  taggable_id: params[:taggable_id], 
                  taggable_type: params[:taggable_type])
    @playlist = Playlist.find(track.playlist_id)
    @sorted = @playlist.sort_playlist
    if tag.save
      @response = {playlist: @playlist, sorted: @sorted}
      tag.tagged_playlist
      respond_with @response 
    else
      redirect_to root_url
    end
  end
end
