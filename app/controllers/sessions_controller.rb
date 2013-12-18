class SessionsController < ApplicationController
  
  def index
    @user = current_user
    @heavy_rotation = RdioUser.heavy_rotation(@user.key, 'true')
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
  end
  
  def create
    reset_session
    user = User.from_omniauth(env["omniauth.auth"])
    if user.id
      banker = Banker.new_account(user.id)
    end
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
