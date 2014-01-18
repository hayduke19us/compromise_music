class FriendshipsController < ApplicationController
  respond_to :js, :html
  def create  
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])  
    if @friendship.save  
      flash[:notice] = "Added friend."  
      @users = users_except_friends
      respond_with @users  
    else  
      flash[:notice] = "Unable to add friend."  
      redirect_to root_url
    end 
  end 

  def users_except_friends
    unless current_user.friends.blank?
      all_users = User.where.not("id IN (#{except_array})")
    else
      all_users = User.where("id != ?", current_user.id)  
    end
    @all_users = all_users
  end
  def except_array
    arr = []
    arr << current_user.id
    current_user.friends.each {|f| arr << f.id}
    arr.join(",")
  end


  def destroy  
    @friend = current_user.friendships.find(params[:id]) 
    @friend.destroy
    flash[:notice] = "You just ended a friendship."  
      redirect_to users_path
  end
end
