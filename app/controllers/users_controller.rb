class UsersController < ApplicationController
  def index
    if  params[:search].blank? 
      @users = User.find(:all, conditions: ["id != ?", current_user.id])
    else
      @users = User.search(params[:search])
    end
                                          
    @friendships = Friend.search(params[:search])
  end
  def show
    @user = User.find(params[:id])
    @friend_view = params[:friend_view]
  end
end
