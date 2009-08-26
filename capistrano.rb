@app_server = ask("What is the hostname of the server where Capistrano should deploy the application?")
@db_server = ask("What is the hostname of the database server?")
@deploy_path = ask("What is the path on the server where Capistrano should deploy the application to?")
@cap_username = ask("What user will be running the application on the server?")

#Install Capistrano gem and capify the app
run "sudo gem install capistrano"
run "capify ."

#And create a reasonable deploy.rb that Capistrano can use
run "rm config/deploy.rb"
file "config/deploy.rb", <<-END
set :application, '#{@app_name}'

set :repository, '#{@git_repo}'
set :scm, :git

set :deploy_to, '#{@deploy_path}/#{@app_name}'

role :app, "#{@app_server}"
role :web, "#{@app_server}"
role :db,  "#{@db_server}", :primary => true

set :user, '#{@cap_username}'
set :runner, '#{@cap_username}'

deploy.task :start do
  run "touch \#{current_path}/tmp/restart.txt"
end

deploy.task :restart do
  run "touch \#{current_path}/tmp/restart.txt"
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch \#{current_path}/tmp/restart.txt"
  end
end

set :ssh_options, {:forward_agent => true}
on :start do
  `ssh-add`
end
END