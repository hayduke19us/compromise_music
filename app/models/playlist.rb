class Playlist < ActiveRecord::Base
  include ActiveModel::Model
  attr_accessor :type, :query
  belongs_to :user
  has_many :tracks
  validates_uniqueness_of :name, :key
  validates_presence_of :name, :description
end
