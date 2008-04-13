class Learning < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  attr_accessible :user_id, :language_id
end
