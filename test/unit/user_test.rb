require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  def setup
	  @english = Language.find_by_code("en")
		@hungarian = Language.find_by_code("hu")
		@french = Language.find_by_code("fr")
    user_attributes = {
      :email => 'john@company.com',
      :login => 'john',
      :password => 'passtoguess',
      :password_confirmation => 'passtoguess' }
    user_with_first_language_attributes = user_attributes.merge({:first_language_id => 1})
    @user = User.create(user_attributes)
		@user.languages.reload
		
		@refuse = Word.create( :name => 'refuse', :language => @english, :user => @user )
    @decline = Word.create( :name => 'decline', :language => @english, :user => @user )
    @refuser = Word.create( :name => 'refuser', :language => @french, :user => @user )
    @box = Word.create( :name => 'box', :language => @english, :user => @user )
		@boite = Word.create( :name => 'boite', :language => @french, :user => @user )
    # @refuse.stubs(:synonyms).returns([@decline, @refuser])
    
  end

  def test_should_require_login
    u = User.create(:login => nil)
    assert u.errors.on(:login)
  end

  def test_login_length_short
    u = User.create(:login => 'go')
    assert u.errors.on(:login)
  end

  def test_login_length_good
    u = User.create(:login => 'bryan')
    assert_nil u.errors.on(:login)
  end

  def test_should_require_password
    u = User.create(:password => '')
    assert u.errors.on(:password)
  end

  def test_password_length_short
    u = User.create(:password => 'pass')
    assert u.errors.on(:password)
  end

  def test_password_length_good
    u = User.create(:password => 'passtoguess')
    assert_nil u.errors.on(:password)
  end

  def test_should_require_email
    u = User.create(:email => nil)
    assert u.errors.on(:email)
  end

  def test_email_length
    u = User.create(:email => 'x@x.x')
    assert u.errors.on(:email)
  end

  def test_email_format
    u = User.create(:email => 'halleluja')
    assert u.errors.on(:email)
  end

  def test_email_format_correct
    u = User.create(:email => 'bryan@company.com')
    assert_nil u.errors.on(:email)
  end

  def test_email_unicity
    u = User.create(:email => @user.email)
    assert u.errors.on(:email)
  end

  def test_random_string
    assert_match(/^\w{7}$/, User.random_string(7))
    assert_match(/^\w{10}$/, User.random_string(10))
  end

  def test_set_password
    @user.update_attribute(:password, "new_password")
    assert_equal @user, User.authenticate(:login => @user.login, :password => "new_password")
  end

  def test_login_unicity
    u = User.create(:login => @user.login)
    assert u.errors.on(:login)
  end

  def test_authenticate_no_such_login
    assert_nil User.authenticate(:login => 'sebastien', :password => 'passtoguess'), 'no such login'
  end

  def test_authenticate_bad_password
    assert_nil User.authenticate(:login => 'john', :password => 'qwerty'), 'bad password'
  end

  def test_authenticate_success
    assert_equal @user, User.authenticate(:login => 'john', :password => 'passtoguess'), 'successful user authentication'
  end

  def test_get_first_language
    assert_equal nil, @user.first_language
    @user.first_language = @english.id
    @user.save
    assert_equal @english, @user.first_language
  end

	def test_get_default_language
		assert_equal(nil, @user.first_language)
		@user.default_language = @english.id
		@user.save
		assert_equal(@english, @user.default_language)
	end
	
  def test_set_first_language
    @user.first_language = @english.id
		@user.save
		@user.reload
    assert @user.languages.include?(@english)
    assert_equal(@english, @user.learnings.select { |l| l.is_first_language }.first.language)
    # assert_equal @english, @user.learnings.first.language
  end

	def test_add_language
		langs_length = @user.languages.length
		@user.add_language(@english)
		# the association has to be reloaded since the learnings -not the languages-
		# association was modified
		@user.languages.reload
		assert_equal(langs_length + 1, @user.languages.length)
		assert @user.languages.include?(@english)
	end

	def test_should_not_allow_multiple_learnings_of_same_langauge
		@user.add_language(@english)
		@user.languages.reload		
		assert_nil @user.add_language(@english)
	end

	def test_hungarian_should_be_default_language_if_not_given_after_saved
		# @user.save
		# @user is already saved when created in setup
		assert_equal(@hungarian, @user.default_language)
	end
	
	def test_get_words_in_language
		my_words = @user.get_words_in_language(@english)
		assert my_words.include?(@box)
		assert my_words.include?(@refuse)
		assert my_words.include?(@decline)
	end
	
	def test_get_word_pairs
		@refuse.synonym = @refuser
		@box.synonym = @boite
		@refuse.save ; @box.save; #@refuser.save; @refuse.synonyms.reload; @box.synonyms.reload		
		word_pairs = @user.get_word_pairs(@english, @french)
		assert word_pairs.include?([@refuse, @refuser])
		assert word_pairs.include?([@box, @boite])
	end
	
end
