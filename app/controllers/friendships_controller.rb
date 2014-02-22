class FriendshipsController < ApplicationController

  respond_to :js, :html

  def create
    if params[:user] && params[:friend]
      user = User.find(params[:user]) 
      @friendship = user.friendships.build(friend_id: params[:friend])
      if @friendship.save
        @users = user.all_others
        respond_with @users
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])
    user = friendship.user
    friendship.destroy
    friendship.delete_associated_groupships
    @users = user.all_others
    respond_with @users
  end
end
