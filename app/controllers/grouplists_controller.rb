class GrouplistsController < ApplicationController
  respond_to :js, :html
  def create
    @playlist = Playlist.find(params[:playlist_id])
    group = Group.find(params[:group_id])  
    grouplist = Grouplist.new(group_id: params[:group_id], 
                              playlist_id: @playlist.id)
    if grouplist.save
      redirect_to root_path
    else
      respond_with @playlist
    end
  end
end
