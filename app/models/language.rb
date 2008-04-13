class Language < ActiveRecord::Base
  has_many :learnings
  has_many :users, :through => :learnings

  validates_presence_of :name, :code
end
