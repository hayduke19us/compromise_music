class Tag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :taggable

  def tagged_playlist
    if self.taggable_type == "Playlist"
      playlist = self.taggable 
      playlist.tracks.each do |track|
        track.tags.build(name: self.name) 
        track.save
      end
    end
  end

  #finding tags by an array of names

  def self.group_by_tag *named_tag
    self.where(name: named_tag) 
  end

  #finding the tagged objects by a name array and returning an array 
  #of tracks if the tagged object is a track

  def self.tagged_tracks *named_tags
    array = []
    Tag.group_by_tag(named_tags).each do |tag|
      array << tag.taggable if tag.taggable_type == "Track"
    end
    array
  end

  #returning an array of tracks if the tagged tracks belong to the user
  #in the arg

  def self.users_tracks user, *tags
    array = []
    Tag.tagged_tracks(tags).each do |track|
      array << track if track.user_id == user.id
    end
    array
  end

end
