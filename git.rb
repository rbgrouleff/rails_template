#Git stuff - creating .gitignore, init a new repo, add it to the Git server with
#the name of the app as the repo name, make an initial commit and push it to master
@git_server = ask("What is the hostname of your git server?")
@git_path = ask("Type the subpath on the git server - if any")
@git_app_path = @git_path == "" ? "#{@app_name}.git" : "#{@git_path}/#{@app_name}.git"
@git_repo = "git@#{@git_server}:#{@git_app_path}"

@git_capistrano_text = <<-END

set :repository, '#{@git_repo}'
set :scm, :git
END

insert_into_file_after "config/deploy.rb", /set :application, '.+'/, @git_capistrano_text if @use_capistrano

#Lets create some .gitignore in some directories, we don't want to be version controlled
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
#{@gitignore_extras.join("\n")}
END

git :init
git :remote => "add origin #{@git_repo}"
git :add => "."
git :commit => '-m "initial commit"'
git :push => "origin master:refs/heads/master"