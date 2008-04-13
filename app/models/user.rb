class User < ActiveRecord::Base
  has_many :words
  has_many :learnings
  has_many :languages, :through => :learnings
  has_one :first_language, :class_name => "Language"

  validates_presence_of :login, :password, :password_confirmation, :email, :salt, :first_language_id
  validates_length_of :login, :within => 3..20
  validates_length_of :password, :within => 6..100
  validates_length_of :email, :minimum => 5
  validates_uniqueness_of :login, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email" # this is taken from http://www.aidanf.net/rails_user_authentication_tutorial
  validates_confirmation_of :password

  # all fields that should not be updateable from the web should be protected
  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(pass, self.salt)
  end

  def self.random_string(len)
    rnd_string = []
    chars = ('a'..'z').to_a + (0..9).to_a
    len.times do |i|
      rnd_string << chars[rand(chars.length)]
    end
    rnd_string.join ''
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end

  def self.authenticate(login, pass)
    u = User.find_by_login(login)
    return u unless u.nil? || self.encrypt(pass, u.salt) != u.hashed_password
  end

end
