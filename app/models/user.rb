class User < ActiveRecord::Base
  acts_as_voter

  validates_presence_of  :provider,
    :uid, :name, :key, :oauth_token, :access_token, :access_secret

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name.downcase
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

  has_one  :banker, :dependent => :destroy
  has_many :tracks, :dependent => :destroy
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :playlists, :dependent => :destroy
  has_many :groups, :dependent => :destroy

  def self.search(search)
    if search
      find(:all, :conditions => ["name LIKE ?", "%#{search}%"])
    else
      find(:all)
    end
  end

  def destroy_remaining_friendships!
    friendships = Friendship.where(friend_id: self)
    friendships.each {|f| f.destroy!}
  end

  def collab_groups
    g = Groupship.where(friend_id: self)
    g.inject([]) {|array, groupship| array << groupship.group}
  end

  def collab_playlists
    self.collab_groups.inject([]) {|array, group| group.playlists.each {|p| array << p }}
  end

  def friends_ids
    self.friends.map {|friend| friend.id}
  end

  def not_friends
    User.where.not(id: self.friends)
  end

  def all_others
    unless self.friends.blank?
      users = self.not_friends.map {|user| user unless user == self}
      users.delete(nil)
      users
    else
      users = User.where.not(id: self)
    end
  end

  def track_tags
    tags = []
    self.tracks.each  {|track| tags << track.tags if track.tags}
    tags.flatten
  end

  def user_tags
    self.track_tags.map {|tag| tag.name }
  end

end
