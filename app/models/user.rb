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

	after_save :set_default_language
	
  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(pass, self.salt)
  end

  def first_language
		first_l = first_learning
		first_l.language unless first_l.nil?
  end

  def first_language=(id)
    language = Language.find(id)
		raise UserError("Can't set nil as first_language") if language.nil?
		learnings.select { |l| l.is_first_language }.each { |l| l.is_first_language = false }
    learnings.build(:language => language,
                          :start_date => Date.today,
                          :is_first_language => true)
  end

	def first_learning
		learnings.select { |l| l.is_first_language }.first
	end

	def default_language
		def_l = default_learning
		def_l.language unless def_l.nil?
	end
	
  def default_language=(id)
    language = Language.find(id)
		learnings.select { |l| l.is_default_language }.each { |l| l.is_default_language = false }
    learnings.build(:language => language,
                          :start_date => Date.today,
                          :is_default_language => true)
  end

  def default_learning
    learnings.select { |l| l.is_default_language }.first
  end

	def add_language(lang, opts={})
		return unless languages.select { |l| l == lang }.empty?
		learning_attrs = {:language => lang, :start_date => Date.today, 
											:is_default_language => false, :is_first_language => false}.merge(opts)
		learnings.create(learning_attrs)
	end
	
	def add_as_default_language(lang)
		raise UserException if lang.nil?
		add_language(lang, :is_default_language => true)
	end
	
	def add_as_first_language(lang)
		add_language(lang, :is_first_language => false)
	end
	
	def set_default_language
		default_lang = Language.find_by_code("hu")
		raise UserException if default_lang.nil?
		add_as_default_language(default_lang) if learnings.select{ |l| l.is_default_language }.empty?
	end
	
	def get_words_in_language(lang)
		words.select { |w| w.language == lang }
	end

	def get_word_pairs(from_lang, to_lang)
		# puts "get words in language: #{get_words_in_language(from_lang).inspect}"
		pairs = Array.new
		word_pairs = get_words_in_language(from_lang).each do |from_word|
			# puts "Word: #{from_word.inspect} Synonyms: #{from_word.synonyms.inspect}"
			to_word = from_word.find_first_synonym_in_language(to_lang)
			pairs << [from_word, to_word] unless to_word.nil?
		end
		pairs
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
