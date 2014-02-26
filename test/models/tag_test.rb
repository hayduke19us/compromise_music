require "test_helper"

class TagTest < ActiveSupport::TestCase

  test "tag sanity test" do
    tag = tags(:one)
    assert tag.valid?
  end

  test "tag must have a name to be valid" do
    tag = tags(:one)
    tag.name = nil
    refute tag.valid?
  end

  test "tags type is accesible thru taggable" do
    tag = tags(:one) 
    assert_equal  "Track", tag.taggable.class.name
  end

  test "the taggable object is accesible" do
    tag = tags(:one)
    assert_equal "ramona", tag.taggable.name
  end

  test "a tag must be unique within the scope of the tagable object" do
    track = tracks(:ramona)
    tag = Tag.new(name: "happy", taggable_type: "Track", taggable_id: track.id)
    refute tag.valid?
  end

  test "playlist can be grouped by tags" do
    tags = Tag.where(name: "happy")
    assert_equal ["ramona", "road trip"], tags.map{|tag| tag.taggable.name} 
  end

  test "group_by_tag can take an array with multiple values for grouping" do
    assert_equal 4, Tag.group_by_tag(["happy", "sad", "travel"]).count
  end

  test "returns the tracks that are grouped my group_by_tag" do
    #no playlist should be returned

    assert_equal 1, Tag.tagged_tracks("happy").count
    assert_equal Track, Tag.tagged_tracks("happy").first.class
  end

end
