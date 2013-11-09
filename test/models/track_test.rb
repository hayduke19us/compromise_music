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
  
end
