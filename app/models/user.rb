class UserException < Exception; end

class User < ActiveRecord::Base
  has_many :words
  has_many :learnings
  has_many :languages, :through => :learnings

  #TODO: validates_presence_of :password and :password_confirmation makes
  # a totally valid user invalid since these are not saved to the model(database)
  # At the same time, these checks are needed to validate the form, so what's the solution?
  validates_presence_of :login, :password, :password_confirmation, :email, :salt
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

  def first_language
    learnings.select { |l| l.is_first_language }.first
  end

  def first_language=(id)
    language = Language.find(id)
    learnings.build(:language => language,
                          :start_date => Date.today,
                          :is_first_language => true)
  end

  def default_language
    learnings.select { |l| l.is_default_language }.first
  end

  def default_language=(id)
    language = Language.find(id)
    learnings.build(:language => language,
                          :start_date => Date.today,
                          :is_default_language => true)
  end

	def add_language(lang, opts={})
		raise UserException unless learnings.collect(&:language).select { |l| l == lang }.empty?
		learning_attrs = {:language => lang, :start_date => Date.today, 
											:is_default_language => false, :is_first_language => false}.merge(opts)
		learnings.build(learning_attrs)
	end
	
	def add_as_default_language(lang)
		add_language(lang, :is_default_language => true)
	end
	
	def add_as_first_language(lang)
		add_language(lang, :is_first_language => false)
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

  def self.authenticate(credentials)
    u = User.find(:first, :conditions => [ 'login = ?', credentials[:login]])
    return u unless u.nil? || self.encrypt(credentials[:password], u.salt) != u.hashed_password
  end

end
