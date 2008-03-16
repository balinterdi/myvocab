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

  def test_find_foreign_words
    foreign_words = @w1.find_foreign_words('hu')
    assert_equal([], foreign_words)
    foreign_words = @w1.find_foreign_words('fr')
    assert_equal(1, foreign_words.length)
    assert_equal(@w3, foreign_words.first)
    # foreign_words = @w1.find_foreign_words('en')

  end
end
