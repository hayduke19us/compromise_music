require "test_helper.rb"

class PlaylistTest < ActiveSupport::TestCase

  test "An empty playlist object it invalid" do
    playlist = Playlist.new
    refute playlist.valid?, "Playlist is missing a proper validation"
  end

  test "A playlist without a name is invalid" do
    playlist = playlists(:road_trip)
    playlist.name = nil
    refute playlist.valid?
  end

  test "A playlist without a description is invalid" do
    playlist = playlists(:road_trip)
    playlist.description = nil
    refute playlist.valid?
  end

  test "A playlist without an embedUrl is invalid" do
    playlist = playlists(:road_trip)
    playlist.embedUrl = nil
    refute playlist.valid?
  end

  test "A playlist without a key is invalid" do
    playlist = playlists(:road_trip)
    playlist.key = nil
    refute playlist.valid?
  end

  test "A playlist without a user_id is invalid" do
    playlist = playlists(:road_trip)
    playlist.user_id = nil
    refute playlist.valid?
  end


  test "A playlist has an association to tracks" do
    playlist = playlists(:road_trip)
    assert_equal 3, playlist.tracks.count
  end

  test "If a playlist is deleted associated tracks are deleted" do
    playlist = playlists(:road_trip)
    assert_equal 3, playlist.tracks.count, "road trip playlist track count '3'"
    tracks = Track.all
    assert_equal 3, tracks.count, "all tracks count '3'"
    playlist.destroy
    assert_equal 0, tracks.count, "tracks count after playlist delete '0'"
  end

  test "VotingGame module exists with playlist class" do
    roadtrip = playlists(:road_trip)
    marthas_friends = groups(:marthas_friends)
    playlist = VotingGame::Playlist.new attributes: roadtrip,
      group: marthas_friends, count: 2, point_adjuster: nil
    refute_nil playlist, "should not be nil"

    assert_equal playlist.attributes.name, roadtrip.name
    assert_equal  playlist.group.name, marthas_friends.name

  end

  test "strategy pattern for VotingGame is cooperating" do
    roadtrip = playlists(:road_trip)
    assert_equal 3, roadtrip.tracks.count, "playlist has 3 tracks"

    marthas_friends = groups(:marthas_friends)
    assert_equal 1, marthas_friends.friends.count, "group has 1 friend"

    playlist = VotingGame::Playlist.new attributes: roadtrip,
      group: marthas_friends,
      count: 2,
      point_adjuster: VotingGame::SuccessFilter.new
    
    success =  playlist.simple_success
    assert_equal 3, success.count, "success_tracks [] has 3 tracks"

  end

end
