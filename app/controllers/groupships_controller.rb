class GroupshipsController < ApplicationController
  respond_to :html, :js
  def create
    @users = users_except_friends
    groupship = Groupship.new(group_id: params[:group_id], 
                              friend_id: params[:friend_id])
    if groupship.save
      respond_with @users
    else
      redirect_to root_path
    end
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



  def destroy
    @group = Group.find(params[:group_id])
    groupship = Groupship.find(params[:id])
    groupship.destroy
    respond_with @group 
  end
end
