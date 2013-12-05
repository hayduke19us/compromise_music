class Grouplist < ActiveRecord::Base
  validates :playlist_id, :group_id, presence: true
  belongs_to :group
  belongs_to :playlist
end
