class User < ActiveRecord::Base
  acts_as_voter
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
      user.save!
    end
  end

has_many :friendships
has_many :friends, :through => :friendships  
has_many :playlists, :dependent => :delete_all

 def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
 end  
end

