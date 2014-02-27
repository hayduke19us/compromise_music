class Playlist < ActiveRecord::Base

  extend My_Rdio
  extend VotingGame

  has_many :grouplists, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :tags, as: :taggable, dependent: :destroy
  belongs_to :user

  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true

  def sort_playlist
    self.tracks.sort_by {|t| t.index}
  end

  def sort_playlist_tracks
    sort_playlist.map {|track| track.key}
  end

  def sort_for_rdio
    My_Rdio::RdioPlaylist.playlist_order self.key, sort_playlist_tracks.join(", ")
  end

  def game
    game = VotingGame::Playlist.new attributes: self,
                               grouplists: self.grouplists,
                               point_adjuster: VotingGame::SuccessFilter.new
  end

  def next_index
    if self.tracks.count == 0
      return 0
    elsif self.tracks.count > 0
      return self.tracks.count
    end
  end

  def tag_compilation track
    unless track.blank?
      index = self.next_index
      @new_track = Track.new(name: track.name,
                             key:  track.key,
                             embedUrl: track.embedUrl,
                             playlist_id: self.id,
                             index: index,
                             user_id: self.user_id,
                             album: track.album,
                             artist: track.artist,
                             album_key: track.album_key,
                             playlist_key: self.key)
      if @new_track.save
        My_Rdio::RdioTrack.add_track self.key, @new_track.key
      end
      return @new_track
    end
  end

end




