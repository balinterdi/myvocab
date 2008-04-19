ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
# helps to build mocks (stubs), see railscast '060_testing_without_fixtures.mov' on railscasts.com
require 'mocha'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...

  @english = Language.create(:name => "english", :code => "en")
  @failing_register_opts_no_password = { :login => 'bryan', :email => 'bryan@bryan.com', :first_language => @english.id }
  @failing_register_opts_badly_repeated_password = @failing_register_opts_no_password.merge({ :password => 'bryanpass', :password_confirmation => 'xxxbryanpass' })

  @successful_register_opts = @failing_register_opts_badly_repeated_password.merge({ :password_confirmation => 'bryanpass'})
  @successful_login_opts = { :login => 'bryan', :password => 'bryanpass' }
  @failing_login_opts_nonexistent_user = { :login => 'bryan_the_rabbit', :password => 'bryanpass' }
  @failing_login_opts_bad_password = { :login => 'bryan', :password => 'xxxbryanpass' }

  def stub_successful_login(user_params)
    user = User.create(user_params)
    User.stubs(:authenticate).returns(user)
    return user
  end

end
