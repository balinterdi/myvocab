require File.dirname(__FILE__) + '/../test_helper'
require 'date'

class LearningTest < Test::Unit::TestCase
  # fixtures :learnings

  #FIXME: what do I say so that it is not settable from web,
  # but settable through associations?
  def XXXtest_start_date_not_settable_from_web
    learning = Learning.new(:user_id => 1, :language_id => 1, :start_date => Date.today)
    assert_nil learning.start_date
  end

  def test_start_date_settable_directly
    learning = Learning.new(:user_id => 1, :language_id => 1)
    learning.start_date = Date.today
    assert_equal learning.start_date, Date.today
  end

end
