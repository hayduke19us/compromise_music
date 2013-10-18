class Playlist < ActiveRecord::Base
  include ActiveModel::Model
  attr_accessor :name, :description, :type, :query
  belongs_to :user
end
