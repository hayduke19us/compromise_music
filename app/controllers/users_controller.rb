class UsersController < ApplicationController
  def index
    @users = User.search(params[:search])
    @all_user = User.find(:all, :conditions => ["id != ?", current_user.id])
    @friendships = Friend.search(params[:search])
  end
end