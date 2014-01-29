class GroupsController < ApplicationController

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
    redirect_to root_path
  end

end
