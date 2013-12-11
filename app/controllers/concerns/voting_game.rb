module Voting_Game
   def self.track_success_filter(playlist, group)
    success_tracks = []
    failure_tracks = []
    friends = group.friends.count
    track_count = playlist.tracks.count
    playlist.tracks.each do |track|
      fair_voting = (friends/track_count - 1)
      unless track.votes_for >= fair_voting 
        failure_tracks << track
        track.destroy
      else
        success_tracks << track
      end  
    end
    
    success_tracks.size - failure_tracks.size
  end
end
