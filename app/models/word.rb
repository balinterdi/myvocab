class Word < ActiveRecord::Base

  has_many :users
  # synonims or words in other languages with the same meaning
  # has_and_belongs_to_many :words
  has_many :meanings
  has_many :synonyms, :through => :meanings, :class_name => 'Word'

  validates_presence_of :name, :lang

  def find_foreign_words(lang)
    find_synonyms { |w| w.lang == lang }
  end

  def find_synonyms(&blk)
    unless block_given?
      blk = lambda { true }
    end
    synonyms.select(&blk)
  end
  # { |syn| syn.lang == options[:lang] }
end
