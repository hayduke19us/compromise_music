class Group < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :user

  has_many :groupships, :dependent => :destroy
  has_many :grouplists, :dependent => :destroy
  has_many :playlists, :through => :grouplists 
  has_many :friends,  :through => :groupships
end
