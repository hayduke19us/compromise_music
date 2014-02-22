class GroupsController < ApplicationController

  def new
  end

  def create
    user = User.find(params[:user_id])
    name = params[:name]
    @name = name_match name
    @group = Group.new(name: @name, user_id: user.id) 
    if @group.save
      redirect_to root_path
    else
      redirect_to new_user_group_path(user) 
    end
  end

  def name_match name
    unless name.blank?
      if name.match(/'/)
        return name.gsub(/'/, '')
      end
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to root_path
  end

  private
    def name_match name
      unless name.blank?
        if name.match(/'/)
          name = name.gsub(/'/, '')
        end
        return name
      end
    end
end
