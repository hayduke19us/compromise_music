module Voting_Game
   def self.track_success_filter(playlist, group)
    success_tracks = []
    friends = group.friends.count
    track_count = playlist.tracks.count
    playlist.tracks.each do |track|
      fair_voting = (friends/track_count)
      unless track.votes_for >= fair_voting 
        failure_tracks << track
        track.destroy
      else
        success_tracks << track
      end  
    end
    for track in success_tracks
      user =  User.find(track.user_id) 
      simple_success(user)
    end
  end
   
  private
  
  #tracks didn't get deleted when the playlist was published
  #the lowest form of success
  
  def simple_success(user)
    user.simple_success = user.simple_success + 1 
    luck_dj.save 
  end 
end
