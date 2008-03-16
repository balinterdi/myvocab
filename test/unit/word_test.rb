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
    synonyms = @w4.find_synonyms.collect(&:name)
    assert_equal([], synonyms)
  end

  def test_find_pairs
    synonyms = @w1.find_synonyms.collect(&:name)
    assert_equal(true, synonyms.include?('decline'))
    assert_equal(true, synonyms.include?('refuser'))
    assert_equal(false, synonyms.include?('box'))
  end

  def XXXtest_pair
    w_en = Word.find_by_name("foray")
    w_hu = Word.find_by_name("fosztogat")
    assert ( w_en.pair("hu") == w_hu )
    assert ( w_hu.pair("en") == w_en )
    w_en = Word.find_by_name("box")
    assert ( w_en.pair("hu") === nil )
  end

end
