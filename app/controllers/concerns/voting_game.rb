module VotingGame
  class Playlist
    attr_reader :group, :count
    attr_accessor :attributes, :point_adjuster 
    def initialize(args)
      @attributes     = args[:attributes]
      @group          = args[:group]
      @count          = args[:count]
      @point_adjuster = args[:point_adjuster]
    end

    def simple_success

      @point_adjuster.simple_success @group, @attributes, @count
    end
  end
  
  class SuccessFilter
    def simple_success group, attributes, count
      success_tracks = []
      attributes.tracks.each do |track|
        if track.votes_for >= group.friends.count/attributes.tracks.count.to_f
          success_tracks << track
        end
        success_tracks
        #VotingGame::SuccessTracks.new(success_tracks).simple_points
     end
    end
  end

  class FailureFilter
    def simple_success group, attributes, count
      failure_tracks = []
      attributes.tracks.each do |track|
        if track.votes_for >= group.friends.count/attributes.tracks.count.to_f
          failure_tracks << track
        end
        #failure = VotingGame::FailureTracks.new(failure_tracks)
        #failure.rdio_delete
        #failure.compromise_delete 
      end
    end
  end

  class FailureTracks
    include My_Rdio
    def initialize(tracks)
      @tracks = tracks
    end

    def rdio_delete
    end

    def compromise_delete
      @tracks.each do |track|
        track.destroy
      end
    end
  end


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
