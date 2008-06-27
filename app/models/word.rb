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
  validates_presence_of :name, :language

  def find_words_for_language(a_language)
    find_synonyms { |w| w.language.code == a_language.code }
  end

  def find_same_language_synonyms
    find_synonyms { |w| w.language.code == language.code }
  end

  def find_foreign_synonyms
    find_synonyms { |w| w.language.code != language.code }
  end

  # Q: so if calling protected methods is also not allowed from tests
  # how do I test them?
  # A: I suppose I don't since I only need to test methods that are available for
  # the "outside world"?

  def find_synonyms(&blk)
    return synonyms unless block_given?
    return synonyms.select(&blk)
  end

end
