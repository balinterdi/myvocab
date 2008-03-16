class Word < ActiveRecord::Base
  # belongs_to :meaning
  has_many :users
  # synonims or words in other languages with the same meaning
  # has_and_belongs_to_many :words
  has_many :meanings
  has_many :synonyms, :through => :meanings, :class_name => 'Word'

  validates_presence_of :name, :lang

  def find_synonyms
    synonyms
  end

  def pair(lang)
    Word.find(:first, :conditions => { :meaning  => meaning, :lang => lang } )
  end
end
