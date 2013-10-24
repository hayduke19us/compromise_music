class UsersController < ApplicationController
  def index
    @users = User.search(params[:search])
    @all_user = User.find(:all, :conditions => [ "id != ?", current_user.id])
    @friendships = Friend.search(params[:search])
  end
  def show
    @user = User.find(params[:id])
    @friend_view = params[:friend_view]
    
  end
end
