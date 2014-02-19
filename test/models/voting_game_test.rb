require 'test_helper'

module VotingGame
  class PlaylistTest < ActiveSupport::TestCase
    def setup 
      roadtrip = playlists(:road_trip)
      grouplists = grouplists(:friend_playlist, :family_playlist)
     @playlist = VotingGame::Playlist.new attributes: roadtrip,
      grouplists: grouplists,
      count: 2,
      point_adjuster: nil
    end

    test "Voting Game must be valid" do
      assert @playlist.class, Object
    end

    test "Voting Game grouplists is an array of grouplists" do
      assert_equal @playlist.grouplists.count, 2
    end

    test "groups method returns groups from grouplist in an array" do
      assert_equal @playlist.groups.count, 2
    end

    test "members returns number of members in groups assocated with playlist" do
      assert_equal @playlist.members, 4, "includes group owners"
    end

    test "members method returns integer or float for comparing with votes" do
      assert_equal @playlist.min_votes.round(1), 1.3, "track vote minimum"
    end

    test "number of tracks is attributes" do
      playlist = @playlist.attributes
      assert_equal 3, playlist.tracks.count
    end
  end

  class SuccessFilterTest < ActiveSupport::TestCase
    def setup 
      @roadtrip = playlists(:road_trip)
      @grouplists = grouplists(:friend_playlist, :family_playlist)
      @success_filter = VotingGame::SuccessFilter.new
    end

    test "simple_success array is getting populated" do
      #for the sake of test the min_vote is at 1

      @success_filter.simple_success(@roadtrip, 1)
      assert_equal @success_filter.success_tracks.count, 2
    end

   test "simple_failure array is getting populated" do
     @success_filter.simple_failure(@roadtrip, 1)
     assert_equal @success_filter.failure_tracks.count, 1
   end
  end
end
