class Playlist < ActiveRecord::Base

  extend My_Rdio
  extend VotingGame

  has_many :grouplists, :dependent => :destroy
  has_many :tracks, :dependent => :destroy
  belongs_to :user

  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true

  def sort_playlist
    sorted_playlist = self.tracks.sort_by {|t| t.index}
    sorted_playlist.map {|track| track.key}
  end

  def sort_for_rdio
    My_Rdio::RdioPlaylist.playlist_order self.key, sort_playlist.join(", ")
  end

  def game
    game = VotingGame::Playlist.new attributes: self,
                               grouplists: self.grouplists,
                               point_adjuster: VotingGame::SuccessFilter.new
  end

end




