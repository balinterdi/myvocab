require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < Test::Unit::TestCase
  fixtures :languages

  def test_should_require_name
    lang = Language.create(:name => nil)
    assert lang.errors.on(:name)
  end

  def test_should_require_code
    lang = Language.create(:code => nil)
    assert lang.errors.on(:code)
  end

  def test_valid_language
    lang = Language.create(:name => "english", :code => "en")
    assert lang.errors.blank?
  end

end
