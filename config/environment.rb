# Be sure to restart your web server when you modify this file.

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session_store = :active_record_store
  
  # add sweepers to load_paths
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  
  # # add all frozen gems to load_paths
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

  # specify required gems
  config.gem 'mini_magick'
  config.gem 'feedvalidator', :lib => 'feed_validator'
  config.gem 'rcov'

end

# set applicaiton cookie session key name
ActionController::Base.session_options[:session_key] = '_netcooler_session_id'

require 'custom_validations' 
