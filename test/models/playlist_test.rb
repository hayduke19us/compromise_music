require "test_helper.rb"

class PlaylistTest < ActiveSupport::TestCase

  def setup
    @playlist = Playlist.new
    @track = Track.new
  end
  def teardown
    @playlist.destroy!
    @track .destroy!
  end
  
  test "Playlist requires validation and attributes to be created" do
    refute  @playlist.valid?, "Playlist is missing a proper validation"
    
    @playlist = playlists(:road_trip)
    refute_nil @playlist.name, "missing name"
    refute_nil @playlist.description, "missing description"
    refute_nil @playlist.id, "missing id"
    refute_nil @playlist.key, "missing key"
    refute_nil @playlist.embedUrl, "missing embed Url"
    refute_nil @playlist.user_id, "missing user_id"
    assert @playlist.valid?, "Playlist is missing an attribute"
    @playlist.save
  end
 
  test "Playlist has an association to tracks" do
    @playlist = playlists(:road_trip)
    @track = tracks(:ramona)
    assert_equal 1, @playlist.tracks.count
  end
  
  test "if Playlist is deleted associated tracks are deleted" do
    playlist = playlists(:road_trip) 
    assert_equal 1, playlist.tracks.count, "road trip playlist track count '1'"
    tracks = Track.all 
    assert_equal 2, tracks.count, "all tracks count '2'" 
    playlist.destroy
    assert_equal 1, tracks.count, "tracks count after playlist delete '1'"
  end
end
