class UsersController < ApplicationController
  def index
    for friend in current_user.friends do 
    @users = User.all.where.not(:id == current_user.id && 
                                :id == friend.id)
    end
    #puts friend's id's in an array for proper listing
    friend_check
  end
  
  def show
    @user = User.find(params[:id])
    @friend_view = params[:friend_view]
  end
  
  private
  def friend_check
    @friend_array = []
    current_user.friends.each {|friend| @friend_array << friend }
    @friend_array << current_user.id
    
    if params[:search].blank? && current_user.friends.empty?
      users = User.where("id != ?", current_user.id)
    elsif params[:search].blank? 
      users = User.where.not(id: @friend_array )
    else
      users = User.search(params[:search]) 
      current_user.friends.each do |friend|
        users.keep_if {|c| c.id != current_user.id}
        users.keep_if {|c| c.id != friend.id}
      end 
    end
      @users = users
  end
end
