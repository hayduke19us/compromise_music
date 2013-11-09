class UsersController < ApplicationController
  def index
    #puts friend's id's in an array for proper listing
    friend_check
  end
  
  def show
    @user = User.find(params[:id])
    @friend_view = params[:friend_view]
  end

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
    end
    @users = users
  end

end
