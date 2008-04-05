require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < Test::Unit::TestCase
  # fixtures :languages

  def test_should_require_name
    lang = Language.create(:name => nil)
    # lang = Language.create(:name => "english", :code => "en")
    assert lang.errors.on(:name)
  end

  def test_should_require_code
    lang = Language.create(:code => nil)
    # lang = Language.create(:name => "english", :code => "en")
    assert lang.errors.on(:code)
  end

end
