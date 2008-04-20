class Language < ActiveRecord::Base
  has_many :learnings
  has_many :users, :through => :learnings

  has_many :words
  # belongs_to :user
  validates_presence_of :name, :code
end
