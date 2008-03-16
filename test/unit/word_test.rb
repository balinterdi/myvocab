require File.dirname(__FILE__) + '/../test_helper'

class WordTest < Test::Unit::TestCase
  fixtures :words, :meanings

  def setup
    @w1 = Word.find_by_name("refuse")
    @w2 = Word.find_by_name("decline")
    @w3 = Word.find_by_name("refuser")
    @w4 = Word.find_by_name("box")
  end

  # Replace this with your real tests.
  def test_truth
    assert true
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
    synonyms = @w4.find_synonyms
    assert_equal([], synonyms)
  end

  def test_find_synonyms
    synonyms = @w1.find_synonyms
    assert_equal(true, synonyms.include?(@w2))
    assert_equal(true, synonyms.include?(@w3))
    assert_equal(false, synonyms.include?(@w4))
    synonyms_names = synonyms.collect(&:name)
    assert_equal(true, synonyms_names.include?('decline'))
    assert_equal(true, synonyms_names.include?('refuser'))
    assert_equal(false, synonyms_names.include?('box'))
  end

  def test_find_words_for_lang
    hu_words = @w1.find_words_for_lang('hu')
    assert_equal([], hu_words)
    fr_words = @w1.find_words_for_lang('fr')
    assert_equal(1, fr_words.length)
    assert_equal(@w3, fr_words.first)
    en_words = @w1.find_words_for_lang('en')
    assert_equal(1, en_words.length)
    assert_equal(true, en_words.include?(@w2))
  end

  def test_find_same_lang_synonyms_empty
    assert_equal([], @w4.find_same_lang_synonyms)
  end

  def test_find_same_lang_synonyms
    syns = @w1.find_same_lang_synonyms
    assert_equal(1, syns.length)
    assert_equal(@w2, syns.first)
  end

  def test_find_foreign_synonyms
    syns = @w1.find_foreign_synonyms
    assert_equal(1, syns.length)
    assert_equal(@w3, syns.first)
    assert_equal(false, syns.include?(@w4))
  end

  def test_find_foreign_synonyms_not_symmetrical
    # the word - synonym pairs have to be
    # explicitly given both ways, which is not desired
    # but it works like this for the moment
    syns = @w3.find_foreign_synonyms
    assert_equal([], syns)
  end

end
