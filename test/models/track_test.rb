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

  test "track index is an integer" do
    track = tracks(:ramona)
    index = track.index
    type = index.class
    assert type.superclass, Integer
  end

  test "track must be unique in a playlist(no replications)" do
    playlist = playlists(:road_trip)
    assert_equal 2, playlist.tracks.count

    track = tracks(:ramona)
    assert track.valid?, "track should be valid"

    track_dup = Track.new(id: 2, name: 'ramona', key: track.key,
                          embedUrl: track.embedUrl, playlist_id: 1,
                          index: 1, user_id: 1 )
    refute track_dup.valid?, "should not be valid scope p_id and key"
  end

  test "when track is deleted the index of other tracks is appended" do
    playlist = playlists(:road_trip)
    assert_equal 2, playlist.tracks.count

    track1 = tracks(:ramona)
    assert_equal 0, track1.index

    track2 = tracks(:imitosis)
    assert_equal 1, track2.index

    test_track1 = Track.find track1.id
    test_track1.index_destroy playlist
    test_track2 = Track.find track2.id
    assert_equal 0, test_track2.index
  end

  test "tracks have and association with vote" do
    track = tracks(:ramona)
    vote = votes(:martha_vote_ramona)
    refute_nil track.votes
  end

  test "tracks can be voted on" do
    track = tracks(:ramona)
    assert_equal 1, track.votes.count
  end
end
