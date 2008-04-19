ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  #FIXME: map.resources auto-generates restful helpers, e.g edit_project_path, new_project_path, etc.

  map.connect '', :controller => 'word', :action => 'all'

  # named routes
  map.register 'register', :controller => 'user', :action => 'register'
  map.home 'index', :controller => 'user', :action => 'index'
  map.login 'login', :controller => 'user', :action => 'login'
  map.user_home 'index', :controller => 'word', :action => 'list'

  map.connect 'register', :controller => 'user', :action => 'register'
  map.connect 'login', :controller => 'user', :action => 'login'
  map.connect 'logout', :controller => 'user', :action => 'logout'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
