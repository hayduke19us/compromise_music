class FriendsController < ApplicationController
  def show
    @user = current_user
    @friend = Friend.find(params[:id])
  end
end
