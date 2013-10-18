class Playlist < ActiveRecord::Base
  include ActiveModel::Model
  attr_accessor :type, :query
  belongs_to :user
  validates_uniqueness_of :name, :key
end
