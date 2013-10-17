class Playlist < ActiveRecord::Base
  include ActiveModel::Model
  attr_accessor :name, :description
  belongs_to :user
end
