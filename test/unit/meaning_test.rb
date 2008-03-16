require File.dirname(__FILE__) + '/../test_helper'

class MeaningTest < Test::Unit::TestCase
  fixtures :meanings, :words

  def test_meaning_associations
    @m = Meaning.find(1)
    word = Word.find(@m.word_id)
    syn = Word.find(@m.synonym_word_id)
    assert_equal('refuse', word.name)
    assert_equal('decline', syn.name)
  end

end
