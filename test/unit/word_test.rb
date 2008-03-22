require File.dirname(__FILE__) + '/../test_helper'

class WordTest < Test::Unit::TestCase

  def setup
    @refuse = Word.new( :name => 'refuse', :lang => 'en' )
    @decline = Word.new( :name => 'decline', :lang => 'en' )
    @refuser = Word.new( :name => 'refuser', :lang => 'fr' )
    @box = Word.new( :name => 'box', :lang => 'en' )
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
    w = Word.create(:lang => nil)
    assert w.errors.on(:lang)
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

  def test_find_words_for_lang
    hu_words = @refuse.find_words_for_lang('hu')
    assert_equal([], hu_words)
    fr_words = @refuse.find_words_for_lang('fr')
    assert_equal(1, fr_words.length)
    assert_equal(@refuser, fr_words.first)
    en_words = @refuse.find_words_for_lang('en')
    assert_equal(1, en_words.length)
    assert_equal(true, en_words.include?(@decline))
  end

  def test_find_same_lang_synonyms_empty
    assert_equal([], @box.find_same_lang_synonyms)
  end

  def test_find_same_lang_synonyms
    syns = @refuse.find_same_lang_synonyms
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

end
