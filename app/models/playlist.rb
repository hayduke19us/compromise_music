class Playlist < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true
end
