class UsersController < ApplicationController
  respond_to :js, :html

  def index
    users_except_friends    
    friend_check
    respond_with friend_check
  end
  
  def show
    @user = User.find(params[:id])
    @friend_view = params[:friend_view]
  end

  def destroy
    user = User.find(params[:id])
    user.destroy_remaining_friendships!
    user.destroy!
    redirect_to root_path
  end
  
  private
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

  def friend_check
    if params[:search].blank? && current_user.friends.empty?
      users = User.where.not("id = ?", current_user.id)
    elsif params[:search].blank? 
      users = User.where.not("id IN (#{except_array})") 
    else params[:search]
      users = User.search(params[:search].downcase)
      ids = []
      users.collect.each {|user| ids << user[:id]}
      unless current_user.friends.count > 0
        ids = ids.reject {|id| id == current_user.id}
      else current_user.friends.count > 0 
        ids = ids.reject{|id| id == current_user.id}
        current_user.friends.each do |f_id|
          ids = ids.reject{|id| id == f_id.id}
        end
      end
      users = User.where("id = ?", ids) 
    end
      @search_users = users
  end
end
