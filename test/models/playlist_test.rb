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
    assert_equal 2, playlist.tracks.count
  end

  test "If a playlist is deleted associated tracks are deleted" do
    playlist = playlists(:road_trip)
    assert_equal 2, playlist.tracks.count, "road trip playlist track count '2'"
    tracks = Track.all
    assert_equal 3, tracks.count, "all tracks count '3'"
    playlist.destroy
    assert_equal 1, tracks.count, "tracks count after playlist delete '1'"
  end
end
