class Grouplist < ActiveRecord::Base
  validates :playlist_id, :group_id, presence: true
  validates_uniqueness_of :group_id, :scope => :playlist_id
  belongs_to :group
  belongs_to :playlist
end
