class GroupshipsController < ApplicationController
  respond_to :html, :js
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
    @group = Group.find(params[:group_id])
    groupship = Groupship.find(params[:id])
    groupship.destroy
    respond_with @group 
  end
end
