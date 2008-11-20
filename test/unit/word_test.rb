require File.dirname(__FILE__) + '/../test_helper'

class WordTest < Test::Unit::TestCase
  fixtures :languages
  
  def setup
		user_attributes = {
      :email => 'john@company.com',
      :login => 'john',
      :password => 'passtoguess',
      :password_confirmation => 'passtoguess' }
		@user = User.create(user_attributes)

    @english = Language.find_by_code("en")
    @french = Language.find_by_code("fr")
    @hungarian = Language.find_by_code("hu")
    
    @refuse = Word.create( :name => 'refuse', :language => @english, :user => @user )
    @decline = Word.create( :name => 'decline', :language => @english, :user => @user )
    @refuser = Word.create( :name => 'refuser', :language => @french, :user => @user )
    @box = Word.create( :name => 'box', :language => @english, :user => @user )
		@boite = Word.create( :name => 'boite', :language => @french, :user => @user )
    @refuse.stubs(:synonyms).returns([@decline, @refuser])
  end

  def test_should_require_name
    # for that to actually work, validation
    # must be enabled in the Word model
    # (with validates_presence_of :name)
    w = Word.create(:name => nil)
    assert w.errors.on(:name)
  end

  def test_should_require_language
    # for that to actually work, validation
    # must be enabled in the Word model
    # (with validates_presence_of :name)
    w = Word.create(:language => nil)
    assert w.errors.on(:language)
  end

  def test_find_synonyms_no_synonyms
    synonyms = @box.find_synonyms
    assert_equal([], synonyms)
  end

  def test_find_synonyms
    synonyms = @refuse.find_synonyms
    assert_equal(true, synonyms.include?(@decline))
    assert_equal(true, synonyms.include?(@refuser))
    assert_equal(false, synonyms.include?(@box))
    synonyms_names = synonyms.collect(&:name)
    assert_equal(true, synonyms_names.include?('decline'))
    assert_equal(true, synonyms_names.include?('refuser'))
    assert_equal(false, synonyms_names.include?('box'))
  end

  def test_find_words_for_language
    hu_words = @refuse.find_words_for_language(@hungarian)
    assert_equal([], hu_words)
    fr_words = @refuse.find_words_for_language(@french)
    assert_equal(1, fr_words.length)
    assert_equal(@refuser, fr_words.first)
    en_words = @refuse.find_words_for_language(@english)
    assert_equal(1, en_words.length)
    assert_equal(true, en_words.include?(@decline))
  end

  def test_find_same_language_synonyms_empty
    assert_equal([], @box.find_same_language_synonyms)
  end

  def test_find_same_language_synonyms
    syns = @refuse.find_same_language_synonyms
    assert_equal(1, syns.length)
    assert_equal(@decline, syns.first)
  end

  def test_find_foreign_synonyms
    syns = @refuse.find_foreign_synonyms
    assert_equal(1, syns.length)
    assert_equal(@refuser, syns.first)
    assert_equal(false, syns.include?(@box))
  end

  def test_find_foreign_synonyms_not_symmetrical
    # the word - synonym pairs have to be
    # explicitly given both ways, which is not desired
    # but it works like this for the moment
    syns = @refuser.find_foreign_synonyms
    assert_equal([], syns)
  end

	def test_synonym?
		assert @refuse.synonym?(@decline)
	end

	def test_set_synonym
		@box.synonym = @boite
		@box.save
		assert @box.synonym?(@boite)
	end
	
	def test_set_synonym_attributes		
		@box.synonym_attributes = { :name => "doboz", :language => @hungarian.id, :user => @user.id }
		@box.save
		assert @box.synonyms.collect(&:name).include?("doboz")
	end
	
end
