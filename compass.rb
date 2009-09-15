gem "chriseppstein-compass", :lib => 'compass', :version => '>= 0.8.10'

rake "gems:install", :sudo => true

run "compass --rails -f blueprint . --css-dir=public/stylesheets --sass-dir=app/stylesheets"

@gitignore_extras << "public/stylesheets/*.css"