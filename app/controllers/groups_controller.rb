class GroupsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @groups = user.groups 
    @groupships = Groupship.where(friend_id: current_user.id)
  end
 
  def new
    
  end
  def create
    name = params[:name]
    if name.match(/'/)
     name = name.gsub(/'/, '')
    end
    group = Group.new(name: name, user_id: params[:user_id])
    if group.save
      redirect_to root_path
    else 
      flash[:notice] = "something went wrong"
      render :new
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    render :index 
  end

end
