class GrouplistsController < ApplicationController
  def create
    playlist = Playlist.find(params[:playlist_id])
    group = Group.find(params[:group_id])  
    grouplist = Grouplist.new(group_id: params[:group_id], 
                              playlist_id: playlist.id)
    if grouplist.save
      redirect_to root_path
    else
      redirect_to root_path
      flash[:notice] = "could not add playlist to group"
    end
  end
end
