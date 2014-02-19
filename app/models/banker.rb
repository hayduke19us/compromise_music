class Banker < ActiveRecord::Base
  validates :user_id, :simple_success, :presence => :true
  validates_uniqueness_of :user_id
  validates :simple_success, numericality: {only_integer: true}

  belongs_to :user

  def self.new_account(user_id, simple_success=0)
    banker = Banker.new(user_id: user_id, simple_success: simple_success)
    banker.save
  end

  def add_simple_point
    self.simple_success += 1
  end

  def subtract_simple_point
    self.simple_success -= 1
  end

  def simple_positive?
    self.simple_success >= 0
  end

  def simple_negative?
    self.simple_success < 0
  end
end
