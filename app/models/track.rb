class Track < ActiveRecord::Base
  belongs_to :playlist
  acts_as_voteable 
  validates :name, :key, :playlist_key, :embedUrl, :index,  presence: true
  validates :index, numericality: { only_integer: true }
end
