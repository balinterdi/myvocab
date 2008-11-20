class Word < ActiveRecord::Base
  belongs_to :user
  has_many :meanings
  has_many :synonyms, :through => :meanings, :class_name => 'Word'
  belongs_to :language

  #TODO: the most elegant solution would be to make synonyms symmetrical
  #If Word A has synonym Word B, then Word B also has Word A as synonym
  # pointers:
  # - an answer to my rails forum question
  # - http://blog.hasmanythrough.com/2006/4/21/self-referential-through
  validates_presence_of :name, :language

	def synonym?(word)
		synonyms.include?(word)
	end
	
	def synonym=(word)
		meanings.build(:synonym => word)
	end

  def find_words_for_language(a_language)
    find_synonyms { |w| w.language.code == a_language.code }
  end

  def find_same_language_synonyms
    find_synonyms { |w| w.language.code == language.code }
  end

  def find_foreign_synonyms
    find_synonyms { |w| w.language.code != language.code }
  end

  def find_synonyms(&blk)
    return synonyms unless block_given?
    return synonyms.select(&blk)
  end

end
