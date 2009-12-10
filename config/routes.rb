ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'

  map.with_options :controller => 'site' do |site|
    site.connect '/index.:format', :action => 'index'
    site.faq     '/faq',           :action => 'faq'
    site.terms   '/terms',         :action => 'terms'
    site.privacy '/privacy',       :action => 'privacy'
    site.about   '/about',         :action => 'about'
  end

  map.check_username '/check_username', :controller => 'users', :action => 'check_username'
  
  map.resources :avatars
  map.resources :industries
  map.resources :searches
  map.resources :states
  map.resources :tags
  
  map.resource :password
  map.resource :session

  map.resources :users,     :has_many => [:posts, :tags, :comments, :avatars]
  map.resources :companies, :has_many => [:posts, :tags]
  
  map.resources :posts do |posts|
    posts.resources :comments
    posts.resources :emails
    posts.resources :ratings, :controller => "post_ratings"
  end

  map.resources :comments do |comments|
    comments.resources :ratings, :controller => "comment_ratings"
  end
  
end