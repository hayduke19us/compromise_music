module VotingGame
  include My_Rdio
  def self.track_success_filter(playlist, group, count)
    success_tracks = []
    failure_tracks = []
    group = group.friends.count
    playlist_count = playlist.tracks.count
    fair_game = group/playlist_count.to_f
    playlist.tracks.each do |track|
      if track.votes_for >= fair_game 
        success_tracks << track
      else
        failure_tracks << track
      end
    end
    rdio_tracks = []
    unless failure_tracks.count <= 0 
      playlist_key = failure_tracks.first.playlist_key
      track_index = failure_tracks.first.index
      failure_tracks.each do |track| 
        rdio_tracks << track.key 
      end 
      rdio_tracks = rdio_tracks.join(', ')
      
      RdioTrack.remove_track(playlist_key, track_index, rdio_tracks,
                             failure_tracks.count) 
      failure_tracks.each do |track|  
        track.delete
      end
    end
    x = 0 
    success_tracks.each do |t|
     t.index = x
     x = x + 1
     t.save
    end
  end
end
