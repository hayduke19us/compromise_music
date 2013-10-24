class Track < ActiveRecord::Base
  belongs_to :playlist
  acts_as_voteable
 
end
