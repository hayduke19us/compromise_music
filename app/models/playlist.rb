class Playlist < ActiveRecord::Base
  has_many :grouplists, :dependent => :destroy 
  has_many :tracks, :dependent => :destroy
  belongs_to :user
  validates :key, uniqueness: true
  validates :name, :description, :key, :embedUrl, :user_id, presence: true
end



