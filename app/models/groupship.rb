class Groupship < ActiveRecord::Base
  belongs_to :group
  belongs_to :friend 
end
