#No easier way to add gem declarations in config/environments/test.rb
run "rm config/environments/test.rb"
file "config/environments/test.rb", <<-END
config.cache_classes = true

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

config.action_controller.allow_forgery_protection    = false

config.action_mailer.delivery_method = :test

config.gem "rspec", :lib => false, :version => ">=1.2.2"
config.gem "rspec-rails", :lib => false, :version => ">=1.2.2"
config.gem "webrat", :lib => false, :version => ">=0.4.3"
config.gem "cucumber", :lib => false, :version => ">=0.2.2"
END

# Install Cucumber'n'stuff
rake "gems:install", :sudo => true, :environment => "test"

#Initializing Cucumber
generate "cucumber"