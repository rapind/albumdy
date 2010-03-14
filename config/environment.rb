# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.gem 'mime-types', :lib => 'mime/types', :version => "= 1.16"
  config.gem 'acts_as_list', :version => "= 0.1.2"
  config.gem 'inherited_resources', :version => "= 0.9.5" # 1.0 & 1.1 are broken in rails 2.3.x
  config.gem 'will_paginate', :version => "= 2.3.12"
  config.gem 'authlogic', :version => "= 2.1.3"
  config.gem 'haml', :version => "= 2.2.19"
  config.gem 'less', :version => "= 1.2.21"
  config.gem 'friendly_id', :version => "= 2.3.0"
  config.gem 'paperclip', :version => "= 2.3.1.1"
  
  config.time_zone = 'UTC'
  
end