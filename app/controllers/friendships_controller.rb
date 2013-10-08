class FriendshipsController < ApplicationController
  def create  
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])  
    if @friendship.save  
      flash[:notice] = "Added friend."  
      redirect_to root_url  
    else  
      flash[:notice] = "Unable to add friend."  
      redirect_to root_url  
    end 
  end 
  def destroy  
    @friend = current_user.friendships.find(params[:id]) 
    @friend.destroy
    flash[:notice] = "You just ended a friendship."  
      redirect_to root_url
  end
end
