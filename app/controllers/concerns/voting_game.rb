module Voting_Game

  def self.track_success_filter(playlist)
    success_tracks = []
    failure_tracks = []
    playlist.tracks.each do |track|
        unless track.votes_for >= 1 
          failure_tracks << track
          track.destroy
        else
          success_tracks << track
        end  
      end
     success_tracks.size - failure_tracks.size
  end
end
