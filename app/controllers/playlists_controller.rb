class PlaylistsController < ApplicationController
  respond_to :html, :json
  def index
    @frog = "frog"
    
    if current_user
     
      @up = current_user.playlists.each do 
        :name
        
        end
    else 
      flash[:notice] =  "Sign in first"
    end  
      
     
  
      
    
  end
  
  def new
  
   
  
    def create
      @playlist = Playlist.new(playlist_params)
      flash[:notice] = 'Playlist was created.' 

      if @playlist.save
        respond_with(@playlist) do |format|
          format.json{render json:
            @playlist.to_json}
        end
      end
    end  
   
  end
  
  def show
    @playlist = Playlist.find(params[:id])
     respond_with(@playlist) do |format|
        format.json{render json:
          @playlist.to_json}
        end
    
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(playlist_params)
      respond_with(@playlist) do |format|
        format.json{render json: 
        @playlist.to_json}
      end
    end
  end
  
  def destroy
   @playlist = Playlist.find(params[:id])
   @playlist.destroy
   if @playlist.destroy
     render 'index'
   end
  end
  def edit
    @playlist = Playlist.find(params[:id])
    @playlist.save
  end
  
  
end
