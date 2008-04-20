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

  map.home '', :controller => 'word', :action => 'most_popular'

  # named routes
  map.with_options :controller => 'user' do |user|
    user.register 'register', :action => 'register'
    user.login 'login', :action => 'login'
    user.logout 'logout', :action => 'logout'
  end

  map.with_options :controller => 'word' do |word|
    word.words_for_user '/words'
  end

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
