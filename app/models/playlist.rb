class Playlist < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  validates_uniqueness_of :name, :key
  validates_presence_of :name, :description
end
