class User < ActiveRecord::Base
  acts_as_voter
  validates :provider, :uid, :name, :key, :oauth_token, :access_token, :access_secret, presence: true 
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.key = auth.extra.raw_info["key"]
      user.oauth_token = auth.credentials.token
      user.oauth_secret = auth.credentials.secret
      user.access_token = auth.extra.access_token.token
      user.access_secret = auth.extra.access_token.secret
      user.oauth_expires_at = Time.now + (12 * 60 * 60)
      user.save!
    end
  end

has_many :friendships, :dependent => :destroy
has_many :friends, :through => :friendships  
has_many :playlists, :dependent => :destroy
  def self.search(search)
    if search
      find(:all, :conditions => ["name LIKE ?", "%#{search}%"])
    else
      find(:all)
    end
  end  
end

