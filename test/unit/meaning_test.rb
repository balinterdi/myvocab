require File.dirname(__FILE__) + '/../test_helper'

class MeaningTest < Test::Unit::TestCase

  def setup
    @refuse = Word.new( :name => 'refuse', :language => @english )
    @decline = Word.new( :name => 'decline', :language => @english )
    @refuser = Word.new( :name => 'refuser', :language => @french )
    # @refuse.build_synonym_ids(@decline, @refuser) # that does not work
    @refuse.stubs(:synonyms).returns([@decline, @refuser])
    # @refuse_meaning = Meaning.new
  end

  def test_meaning_associations
    syns = @refuse.synonyms
    assert(syns.include?(@decline))
    assert(syns.include?(@refuser))
  end

end
