class FriendshipsController < ApplicationController

  respond_to :js, :html

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added friend."
      @users = current_user.all_others
      respond_with @users
    else
      flash[:notice] = "Unable to add friend."
      redirect_to root_url
    end
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    friendship.destroy
    friendship.delete_associated_groupships
    flash[:notice] = "You just ended a friendship."
    @users = current_user.all_others
    respond_with @users
  end
end
