require "test_helper"

class TracksTest < ActiveSupport::TestCase

  def setup
    @track = Track.new
  end

  def teardown
    @track.destroy!
  end

  test "require name, key, playlist_key to be valid" do
    
    refute @track.valid?, "a validation parameter is missing in the model"
    assert_nil @track.name
    assert_nil @track.key
    assert_nil @track.playlist_key
    assert_nil @track.playlist
    assert_nil @track.embedUrl
    assert_nil @track.index

    @track = tracks(:ramona)

    refute_nil @track.id, "missing id" 
    refute_nil @track.name, "missing name"
    refute_nil @track.key, "missing key"
    refute_nil @track.playlist_key, "missing playlist_key"
    refute_nil @track.playlist_id, "missing playlist association thru foreign key"
    refute_nil @track.embedUrl, "missing embedUrl"
    refute_nil @track.index, "missing index"
    assert @track.valid?, "can't create track, is missing an attribute"
  end

  test "require an association to playlist" do
    @track.must_respond_to :playlist
  end

end
