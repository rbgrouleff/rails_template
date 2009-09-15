# Lets just start out with creating a small helper method
def insert_into_file_after(file_name, pattern, text)
  lines = ""
  File.foreach file_name do |line|
    lines << line
    lines << text if line =~ pattern
  end
  File.open file_name, "w" do |file|
    file.puts lines
  end
end

@app_name = @root.split('/').last.strip
@base_path = "http://github.com/rbgrouleff/rails_template.git"

# If there are anything extra that needs to be ignored than the default stuff, then add the lines to this array
@gitignore_extras = []

#Gems needed
gem 'haml'

load_template "#{@base_path}/cucumber.rb" if yes?("Use Cucumber for BDD?")
load_template "#{@base_path}/authlogic.rb" if yes?("Use Authlogic?")
load_template "#{@base_path}/compass.rb" if yes?("Use Compass (and Blueprint)?")

#Install any missing gems
rake "gems:install", :sudo => true
rake "gems:unpack"

rake "rails:freeze:gems", :sudo => true

#Security measures
run "cp config/database.yml config/example_database.yml"

#We want to define our own root mapping (please remember that)
run "rm public/index.html"

#Can't live without Haml
run "haml --rails ."

@use_capistrano = yes?("Use Capistrano for deployment?")
load_template "#{@base_path}/capistrano.rb" if @use_capistrano

load_template "#{@base_path}/git.rb" if yes?("Use git SCM?")