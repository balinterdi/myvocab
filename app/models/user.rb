class User < ActiveRecord::Base
  has_many :words

  validates_presence_of :login, :password, :email
  validates_length_of :login, :within => 3..20
  validates_length_of :password, :within => 6..100
  validates_length_of :email, :minimum => 5
  validates_uniqueness_of :login, :email
  # this is taken from http://www.aidanf.net/rails_user_authentication_tutorial
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"

  # all fields that should not be updateable from the web should be protected
  attr_protected :id

  def self.authenticate(login, pass)
    User.find_by_login(login)
  end
end
