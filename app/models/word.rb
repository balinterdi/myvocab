class Word < ActiveRecord::Base

  has_many :users
  # synonims or words in other languages with the same meaning
  # has_and_belongs_to_many :words
  has_many :meanings
  has_many :synonyms, :through => :meanings, :class_name => 'Word'

  validates_presence_of :name, :lang

  def find_words_for_lang(language)
    find_synonyms { |w| w.lang == language }
  end

  def find_same_lang_synonyms
    find_synonyms { |w| w.lang == lang }
  end

  def find_foreign_synonyms
    find_synonyms { |w| w.lang != lang }
  end

  # so if calling protected methods is also not allowed from tests
  # how do I test them?
  # protected

  def find_synonyms(&blk)
    return synonyms unless block_given?
    return synonyms.select(&blk)
  end

end
