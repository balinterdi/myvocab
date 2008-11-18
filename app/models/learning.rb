class Learning < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_presence_of :start_date
  def self.default_first_language
    Language.find_by_code("en")
  end
  
  # attr_accessible :user_id, :language_id
end
