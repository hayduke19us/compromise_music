class SessionsController < ApplicationController
  respond_to :js, :html

  def index
    if current_user
      @user = current_user
      @collab_groups = @user.collab_groups
      @collab_playlists = @user.collab_playlists

      #sorted tracks by votes for playlist
      unless @sorted.blank?
        @sorted = @playlist.sort_playlist
      end

    end
    @online_users = User.where("online = ? AND id != ?", true, current_user)
  end

  def my_playlist
    @playlist = Playlist.find(params[:playlist])
    @sorted = @playlist.sort_playlist
    respond_with @playlist
  end

  def my_group
    @group = Group.find(params[:group])
    respond_with @group
  end

  def my_friend
   @users = users_except_friends
   respond_with @user
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
    if current_user
      user = User.find current_user.id
      user.online = false
      user.save
    end
    session[:user_id] = nil
    redirect_to "http://warm-wave-8683.herokuapp.com"
  end

end
