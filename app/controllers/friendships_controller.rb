class FriendshipsController < ApplicationController
  def create  
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])  
    if @friendship.save  
      flash[:notice] = "Added friend."  
      redirect_to users_path 
    else  
      flash[:notice] = "Unable to add friend."  
      redirect_to users_path 
    end 
  end 
  def destroy  
    @friend = current_user.friendships.find(params[:id]) 
    @friend.destroy
    flash[:notice] = "You just ended a friendship."  
      redirect_to users_path
  end
end
