@app_name = @root.split('/').last.strip
@base_path = "/Users/rasmusgrouleff/dev/rails-templates"
@git_server = ask("What is the hostname of your git server?")
@git_repo = "git@#{@git_server}:#{@app_name}.git"

#Gems needed
gem 'haml'
gem 'authlogic'
gem "chriseppstein-compass", :lib => 'compass', :version => '>= 0.8.10'

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

#Install any missing gems
rake "gems:install", :sudo => true
rake "gems:install", :sudo => true, :environment => "test"

rake "rails:freeze:gems", :sudo => true

#Lets create some .gitignore in some directories, we don't want to be version controlled
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

#Security measures
run "cp config/database.yml config/example_database.yml"

#We want to define our own root mapping (please remember that)
run "rm public/index.html"

#Can't live without Haml, Compass and Blueprint
run "haml --rails ."
run "compass --rails -f blueprint . --css-dir=public/stylesheets --sass-dir=app/stylesheets"

#Initializing Cucumber
generate "cucumber"

load_template "#{@base_path}/capistrano.rb" if yes?("Use Capistrano for deployment?")

#Git stuff - creating .gitignore, init a new repo, add it to remote (@nerdd.dk) with
#the name of the app as the repo name, make an initial commit and push it to master
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
public/stylesheets/*.css
END
git :init
git :remote => "add origin #{@git_repo}"
git :add => ".", :commit => '-m "initial commit"'
git :push => "origin master:refs/heads/master"