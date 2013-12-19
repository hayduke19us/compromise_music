class UsersController < ApplicationController

  def index
      unless current_user.friends.blank?
        all_users = User.where.not("id = ? OR id = ?",
                                    current_user.id, 
                                    current_user.friends.each {|f| p f.id })
        else
        all_users = User.where.not(id: current_user)  
      end
      @all_users = all_users
      #puts friend's id's in an array for proper listing
    friend_check
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
  def friend_check
    @friend_array = []
    current_user.friends.each {|friend| @friend_array << friend.id }
    @friend_array << current_user.id
    
    if params[:search].blank? && current_user.friends.empty?
      users = User.where.not(id: current_user.id)
    elsif params[:search].blank? 
      users = User.where.not("id = ? OR id = ?", 
                             current_user.id, 
                             current_user.friends.each {|f| p f}  )
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
