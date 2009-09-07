#Git stuff - creating .gitignore, init a new repo, add it to the Git server with
#the name of the app as the repo name, make an initial commit and push it to master
@git_server = ask("What is the hostname of your git server?")
@git_path = ask("Type the subpath on the git server - if any")
@git_app_path = @git_path == "" ? "#{@app_name}.git" : "#{@git_path}/#{@app_name}.git"
@git_repo = "git@#{@git_server}:#{@git_app_path}"

#Lets create some .gitignore in some directories, we don't want to be version controlled
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

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