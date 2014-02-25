require "test_helper"

class TracksTest < ActiveSupport::TestCase

  test "if track is empty then track is invalid" do
    track = Track.new
    refute track.valid?, "a validation parameter is missing in the model"
  end

  test "if track is populated then is valid" do
    track = tracks(:ramona)
    assert track.valid?, "can't create track, is missing an attribute"
  end

  test "track requires name to be valid" do
    track = tracks(:ramona)
    track.name = nil
    refute track.valid?
  end

  test "track requires key to be valid" do
    track = tracks(:ramona)
    track.key = nil
    refute track.valid?
  end

  test "track requires embedUrl to be valid" do
    track = tracks(:ramona)
    track.embedUrl = nil
    refute track.valid?
  end

  test "track requires playlist_id to be valid" do
    track = tracks(:ramona)
    track.playlist_id = nil
    refute track.valid?
  end

  test "track requires index to be valid" do
    track = tracks(:ramona)
    track.index = nil
    refute track.valid?
  end

  test "track index must be an integer to be valid" do
    track = tracks(:ramona)
    track.index = "one"
    refute track.valid?
  end

  test "track must be unique in a playlist(no replications)" do
    user = users(:martha)
    playlist = playlists(:road_trip)
    track = tracks(:ramona)
    track_dup = Track.new(id: track.id,
                          name: track.name,
                          key: track.key,
                          embedUrl: track.embedUrl,
                          playlist_id: playlist.id,
                          index: track.id,
                          user_id: user.id)
    refute track_dup.valid?, "should not be valid scope p_id and key"
  end

  test "when track is deleted the index of other tracks is appended" do
    playlist = playlists(:road_trip)
    assert_equal 3, playlist.tracks.count

    track1 = tracks(:ramona)
    assert_equal 0, track1.index

    track2 = tracks(:armchairs)
    assert_equal 1, track2.index

    track3 = tracks(:imitosis)
    assert_equal 2, track3.index

    test_track1 = Track.find track1.id
    test_track1.index_destroy playlist
    test_track2 = Track.find track2.id
    assert_equal 0, test_track2.index

    test_track3 = Track.find track3.id
    assert_equal 1, test_track3.index
  end

  test "tracks have and association with vote" do
    track = tracks(:ramona)
    assert_respond_to track, votes
  end

  test "tracks can be voted on" do
    track = tracks(:ramona)
    assert_equal 1, track.votes_for, "ramona has one vote for"
  end

  test "tracks total vote value is (for - against)" do
    track = tracks(:ramona)
    total_vote = track.votes_for - track.votes_against
    assert_equal 0, total_vote, "ramona track has total vote value of 0"

    track2 = tracks(:armchairs)
    total_vote_2 = track2.votes_for - track2.votes_against
    assert_equal 1, total_vote_2, "imitosis track has total vote value of 1"

    track3 = tracks(:imitosis)
    total_vote_3 = track3.votes_for - track3.votes_against
    assert_equal 1, total_vote_3, "armchairs .....1"
  end

  test "indexing of all tracks is appended with index_after method" do
    track = tracks(:ramona)
    assert_equal 0, track.index, "ramona should start w/ index of 0"

    track2 = tracks(:armchairs)
    assert_equal 1, track2.index

    track3 = tracks(:imitosis)
    assert_equal 2, track3.index

    track.index_after
    ramona = Track.find(track)

    assert_equal 2, ramona.index
  end

  test "a user can't vote on a track twice" do
    martha = users(:martha)
    track = tracks(:ramona)
    vote = Vote.new vote: true, voteable_type: "Track", voteable_id: track.id,
      voter_id: martha.id, voter_type: "User"
    refute vote.valid?, "martha has already voted on ramona track"
  end

  test "tracks have an associatoion to tags" do
    track = tracks(:ramona)
    assert_respond_to track, tags
  end

  test "a track can be tagged" do
    track = tracks(:ramona)
    assert_equal 1, track.tags.count
  end

  test "a track can be taggd multiple times" do
    track = tracks(:ramona)
    track.tags.build(name: "cloudy")
    track.save
    assert_equal 2, track.tags.count
  end

end
