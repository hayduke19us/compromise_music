class Friend < User 
  has_many :groupships, :dependent => :destroy
end
