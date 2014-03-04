class Movie < ActiveRecord::Base
  attr_accessible :director, :genre, :link, :rating, :runtime, :title, :year
  validates :title, uniqueness: true
end
