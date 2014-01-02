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
    assert_equal 3, playlist.tracks.count

    track = tracks(:ramona)
    assert track.valid?, "track should be valid"

    track_dup = Track.new(id: 2, name: 'ramona', key: track.key,
                          embedUrl: track.embedUrl, playlist_id: 1,
                          index: 1, user_id: 1 )
    refute track_dup.valid?, "should not be valid scope p_id and key"
  end

  test "when track is created its index is determined by its total votes" do
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
    vote = votes(:martha_vote_for_ramona)
    refute_nil track.votes_for
    assert_equal 1, track.votes_for, "should be one"
    assert_equal 1,  track.votes_against, "should be none"
  end

  test "tracks can be voted on" do
    track = tracks(:ramona)
    assert_equal 1, track.votes_for, "ramona has one vote for"
    assert_equal 1, track.votes_against, "ramona has one vote against"
    assert_equal 2, track.votes.count
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

    playlist = Playlist.find track.id
    assert_equal 3, playlist.tracks.count

    track.index_after
    ramona = Track.find track.id
    assert_equal 2, ramona.index
  end

  test "a user can't vote on a track twice" do
    martha = users(:martha)
    track = tracks(:ramona)
    vote = Vote.new vote: true, voteable_type: "Track", voteable_id: track.id,
      voter_id: martha.id, voter_type: "User" 
    refute vote.valid?, "martha has already voted on ramona track"
  end
  
  test "a track is :vote_up" do
    tom = users(:tom)
    track = tracks(:armchairs)
    assert_equal 1, track.votes_for
    track.vote_up tom

    track = Track.find track.id
    total_votes = track.votes_for - track.votes_against
    assert_equal 2, total_votes
  end

end
