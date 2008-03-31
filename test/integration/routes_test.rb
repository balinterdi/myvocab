require "#{File.dirname(__FILE__)}/../test_helper"

class RoutesTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_routes
    opts = { :controller => "user", :action => "register" }
    assert_routing "register", opts
    assert_equal "/register", url_for(opts.merge(:only_path => true))

    opts = { :controller => "user", :action => "login" }
    assert_routing "login", opts
    assert_equal "/login", url_for(opts.merge(:only_path => true))

    opts = { :controller => "user", :action => "logout" }
    assert_routing "logout", opts
    assert_equal "/logout", url_for(opts.merge(:only_path => true))

    assert_not_nil register_url
    assert_not_nil home_path

  end

end
