class GroupshipsController < ApplicationController
  def create
    groupship = Groupship.new(group_id: params[:group_id], 
                              friend_id: params[:friend_id])
    if groupship.save
      redirect_to root_path 
    else
      redirect_to root_path
    end
  end

  def destroy
    groupship = Groupship.find(params[:id])
    groupship.destroy
    redirect_to user_groups_path(current_user)
  end
end
