class Track < ActiveRecord::Base
  include My_Rdio
  belongs_to :playlist
  belongs_to :user
  acts_as_voteable
  validates :name, :key, :playlist_id, :playlist_key,
    :embedUrl, :index,  presence: true
  validates :index, numericality: { only_integer: true }

  def vote_up user
    user.vote_for self
  end

  def vote_down user
    user.vote_against self
  end

  def destroy_with_rdio(count=1)
    playlist = Playlist.find self.playlist_id
    RdioTrack.remove_track(self.playlist_key, self.index, self.key, count)

    self.index_destroy playlist 
  end

  def index_destroy playlist
    playlist.tracks.each do |t|
      unless t.index <= self.index
        t.index -= 1
        t.save
      end
    end
  end


end
