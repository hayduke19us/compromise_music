module VotingGame
  class Playlist

    attr_accessor :attributes, :point_adjuster, :grouplists

    def initialize(args)
      @attributes     = args[:attributes]
      @grouplists     = args[:grouplists]
      @point_adjuster = args[:point_adjuster]
    end

    def groups
      self.grouplists.map {|grouplist| grouplist.group }
    end

    def members
      sum = 0
      groups.each {|group| sum += group.friends.count }
      sum + self.grouplists.count # 1 owner per group
    end

    def min_votes
      members/self.attributes.tracks.count.to_f
    end

    def simple_success
      @point_adjuster.simple_success self.attributes, min_votes
      @point_adjuster.simple_failure self.attributes, min_votes
      @point_adjuster.points
    end
  end

  class SuccessFilter
    attr_accessor :success_tracks, :failure_tracks
    def initialize
      @success_tracks = []
      @failure_tracks = []
      @total_votes = lambda {|track| total = track.votes_for - track.votes_against}
    end

    def simple_success attributes, min_votes
      attributes.tracks.each do |track|
        if @total_votes.call(track) >= min_votes
          self.success_tracks = self.success_tracks << track
        end
      end
    end

    def simple_failure  attributes, min_votes
      attributes.tracks.each do |track|
        if @total_votes.call(track) < min_votes
          self.failure_tracks << track
        end
      end
   end

   def points
      unless self.success_tracks.blank?
        VotingGame::SuccessTracks.new(self.success_tracks).simple_success_points
      end
      unless self.failure_tracks.blank?
        simple_failure_points self.failure_tracks
        failure = VotingGame::FailureTracks.new(failure_tracks)
        failure.rdio_delete
        failure = VotingGame::FailureTracks.new(failure_tracks)
        failure.compromise_delete
      end
    end

    def simple_failure_points tracks
      tracks.each do |track|
        banker = Banker.find_by(user_id: track.user_id)
        banker.simple_success -= 1
        banker.save
      end
    end
  end

  class SuccessTracks
    def initialize tracks
      @tracks = tracks
    end

    def simple_success_points
      @tracks.each do |track|
        banker = Banker.find_by(user_id: track.user_id)
        banker.simple_success += 1
        banker.save
        banker.simple_success
      end
    end
  end

  class FailureTracks
    include My_Rdio

    def initialize tracks
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
      async = []
      @tracks.each {|track| async << track}
      async
    end
  end
end
