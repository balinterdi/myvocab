class Word < ActiveRecord::Base
  has_many :users
  has_many :meanings
  has_many :synonyms, :through => :meanings, :class_name => 'Word'

  # TODO: test the word-language relation
  belongs_to :language
  belongs_to :user
  #TODO: the most elegant solution would be to make synonyms symmetrical
  #If Word A has synonym Word B, then Word B also has Word A as synonym
  # pointers:
  # - an answer to my rails forum question
  # - http://blog.hasmanythrough.com/2006/4/21/self-referential-through
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
