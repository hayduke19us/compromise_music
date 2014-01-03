class SessionsController < ApplicationController

  def index
    @user = current_user
    @friends_groups = Array.new
    if current_user
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
    @online_users = User.where("online = ? AND id != ?", true, current_user)
  end

  def create
    reset_session
    user = User.from_omniauth(env["omniauth.auth"])
    user.online = true
    user.save
    unless user.banker
      banker = Banker.new_account(user.id)
    end
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    user = User.find current_user.id
    user.online = false
    user.save
    session[:user_id] = nil
    redirect_to root_url
  end

end
