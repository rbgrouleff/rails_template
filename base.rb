@app_name = @root.split('/').last.strip
@base_path = "http://github.com/rbgrouleff/rails_template.git"

#Gems needed
gem 'haml'
gem "chriseppstein-compass", :lib => 'compass', :version => '>= 0.8.10'

load_template "#{@base_path}/cucumber.rb" if yes?("Use Cucumber for BDD?")
load_template "#{@base_path}/authlogic.rb" if yes?("Use Authlogic?")

#Install any missing gems
rake "gems:install", :sudo => true

rake "rails:freeze:gems", :sudo => true

#Security measures
run "cp config/database.yml config/example_database.yml"

#We want to define our own root mapping (please remember that)
run "rm public/index.html"

#Can't live without Haml, Compass and Blueprint
run "haml --rails ."
run "compass --rails -f blueprint . --css-dir=public/stylesheets --sass-dir=app/stylesheets"

load_template "#{@base_path}/capistrano.rb" if yes?("Use Capistrano for deployment?")

load_template "#{@base_path}/git.rb" if yes?("Use git SCM?")