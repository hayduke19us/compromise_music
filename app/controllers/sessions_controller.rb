class SessionsController < ApplicationController
  respond_to :js, :html
  
  def index
    if current_user
      if params[:group]
        @group = Group.find(params[:group])
      end
      @user = current_user
      if params[:playlist]
        @playlist = Playlist.find(params[:playlist])
      else 
        @playlist = @user.playlists.first
      end
      unless @sorted.blank?
        @sorted = @playlist.tracks.sort_by {|t| t.index}
      end
    end
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
 
  def search_helper
    if params[:query]
      rdio_search =  RdioSearch.new(search_type: params[:search_type],
                                      query: params[:query])
      @search_results = rdio_search.simple
    elsif params[:artist_key_tracks] 
      @search_results = RdioSearch.new(
        artist_key: params[:artist_key_tracks]).artist_tracks(
        params[:artist_query])
    elsif params[:list]
      @album_tracks = RdioSearch.new(list: params[:list]).album_tracks
    elsif params[:artist_key]
      rdio_search = RdioSearch.new(artist_key: params[:artist_key])
      @search_results = rdio_search.artist_albums
    end
  end

  def my_playlist
    @playlist = Playlist.find(params[:playlist])
    @sorted = @playlist.tracks.sort_by {|t| t.index}
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
