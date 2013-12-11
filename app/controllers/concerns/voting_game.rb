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
      Voting_Game.simple(user)
    end
  end
   
  #tracks didn't get deleted when the playlist was published
  #the lowest form of success
   private
  def self.simple(user)
    banker = user.banker
    banker.simple_success = banker.simple_success + 1
    banker.save 
  end 
end
