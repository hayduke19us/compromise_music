class SessionsController < ApplicationController
  
  def index
    @user = current_user
    @friends_groups = Array.new
    @user.friends.each do |friend|
      for group in friend.groups
        group.friends.each do |member|
          if member.id == @user.id
            @friends_groups << group
          end
        end
      end
    end
  end
  
  def create
    reset_session
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
