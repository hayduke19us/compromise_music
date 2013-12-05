class GroupsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @groups = user.groups 
  end
 
  def new
    
  end
  def create
    group = Group.new(name: params[:name], user_id: params[:user_id])
    if group.save
      redirect_to root_path
    else 
      flash[:notice] = "something went wrong"
      render :new
    end
  end

end
