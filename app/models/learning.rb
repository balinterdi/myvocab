class Learning < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_presence_of :start_date

  # attr_accessible :user_id, :language_id
end
