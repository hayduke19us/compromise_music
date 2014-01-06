module VotingGame
  class Playlist
    attr_reader :group
    attr_accessor :attributes, :point_adjuster
    def initialize(args)
      @attributes     = args[:attributes]
      @group          = args[:group]
      @point_adjuster = args[:point_adjuster]
      @members = (@group.friends.count + 1)/@attributes.tracks.count.to_f
      @total_votes = lambda {|track| total = track.votes_for - track.votes_against}
    end

    def simple_success
      @point_adjuster.simple_success @attributes, @members, @total_votes
      @point_adjuster.simple_failure @attributes, @members, @total_votes
    end
  end

  class SuccessFilter
    def simple_success attributes, members, total_votes
      success_tracks = []
      attributes.tracks.each do |track|
        if total_votes.call(track) >= members
          success_tracks << track
        end
      end
        success_tracks
        #VotingGame::SuccessTracks.new(success_tracks).simple_points
    end

    def simple_failure  attributes, members, total_votes
      failure_tracks = []
      attributes.tracks.each do |track|
        if total_votes.call(track) < members
          failure_tracks << track
        end
      end
      unless failure_tracks.empty?
        failure = VotingGame::FailureTracks.new(failure_tracks)
        failure.rdio_delete
        failure = VotingGame::FailureTracks.new(failure_tracks)
        failure.compromise_delete
      end
    end
  end

  class FailureTracks
    include My_Rdio
  
    def initialize(tracks)
      @tracks = tracks.sort_by {|track| track.index }
    end

    def rdio_delete
      arr = []
      @tracks.each {|t| arr << t.key}
      arr = arr.join(",")
      RdioTrack.remove_track @tracks.first.playlist_key,
                             @tracks.first.index,
                             arr,
                             @tracks.count
    end

    def compromise_delete
      @async = []
      @tracks.each do |track|
        track.destroy
      end
    end
  end
end
