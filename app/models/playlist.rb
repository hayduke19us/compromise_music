class Playlist < ActiveRecord::Base
  has_many :tracks, :dependent => :delete_all
  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true
end
