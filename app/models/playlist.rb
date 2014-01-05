class Playlist < ActiveRecord::Base
  include VotingGame
  has_many :grouplists, :dependent => :destroy 
  has_many :tracks, :dependent => :destroy
  belongs_to :user
  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true
  
  def sort_playlist
    sorted_playlist = self.tracks.sort_by {|t| t.index}
    sorted_tracks = []
    sorted_playlist.each {|track| sorted_tracks << track.key}
    sorted_tracks
  end
  
  def sort_for_rdio
    sorted = self.sort_playlist.join(", ")
    RdioPlaylist.playlist_order self.key, sorted
  end 
end




