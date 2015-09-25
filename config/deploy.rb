# config valid only for current version of Capistrano
lock '3.4.0'

require "capistrano/bundler"

# Define your server here
server "159.203.78.204", roles: %w{web app db}, primary: true

# Set application settings
set :application, "foreman4rails"
set :user, "deploy" # As defined on your server
set :deploy_to, "/home/deploy/apps/foreman4rails" # Directory in which the deployment will take place
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repo_url, "git@github.com:dev9seucondominio/foreman4rails.git"
set :branch, "master"

set :pty, true
set :forward_agent, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        run "/etc/init.d/unicorn_foreman4rails #{command}" # Using unicorn as the app server
      end
    end
  end

  task :setup_config do
    on roles(:app) do
#      sudo "ln -nfs #home/deploy/apps/foreman4rails/current/config/nginx.conf /etc/nginx/sites-enabled/foreman4rails"
#      sudo "ln -nfs #home/deploy/apps/foreman4rails/current/config/unicorn_ini.sh /etc/init.d/unicorn_foreman4rails"
#      put File.read("config/database.yml"), "#home/deploy/apps/foreman4rails/shared/config/database.yml"
#      puts "Now edit the config files in #{shared_path}."
    end
  end
  after "deploy", "deploy:setup_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end  
  end
  before "deploy", "deploy:check_revision"
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      rvmsudo "bundle exec foreman export upstart /etc/init -a foreman4rails -u deploy -l /var/foreman4rails/log"
    end
  end
  
  desc "Start the application services"
  task :start do
    on roles(:app) do
      rvmsudo "service unicorn_foreman4rails start"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      rvmsudo "service unicorn_foreman4rails stop"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      rvmsudo "service unicorn_foreman4rails restart"
    end
  end
end

after "deploy", "foreman:export"
after "deploy", "foreman:restart"