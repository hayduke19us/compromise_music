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

  def self.group_by_tag named_tag
    self.where(name: named_tag) 
  end
end
