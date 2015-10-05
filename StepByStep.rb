*******************************************************************************
*  *****************************'*************'*****************************  *
* *'*'**'*':**'*'**'*':**'*'**'*'M A C H I N E'*'**'*':**'*'**'*':**'*'**'*'* *
*  *****************************'*************'*****************************  *
*******************************************************************************

Instalar Ruby 2.2.3: sudo apt-get update
		     sudo apt-get install libgmp3-dev
		     sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev





Instalar RVM: sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
	      curl -L https://get.rvm.io | bash -s stable
	      source ~/.rvm/scripts/rvm
	      rvm install 2.2.3
              rvm use 2.2.3 --default
 	      ruby -v





Instalar Bundler gem: echo "gem: --no-ri --no-rdoc" > ~/.gemrc
		 gem install bundler





Instalar NodeJS: sudo add-apt-repository ppa:chris-lea/node.js
		 sudo apt-get update
		 sudo apt-get install nodejs





Instalar Rails 4.2.4: gem install rails -v 4.2.4
		      rails -v





Instalar PostgreSQL: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
		     wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
		     sudo apt-key add -
		     sudo apt-get update
		     sudo apt-get install postgresql-common
		     sudo apt-get install postgresql-9.4 postgresql-contrib libpq-dev
		     psql -V





Instalar Nginx: gpg --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
		gpg --armor --export 561F9B9CAC40B2F7 | sudo apt-key add -
		sudo apt-get install apt-transport-https
		sudo apt-get update
		sudo apt-get install nginx-full
		nginx -v





Adicionar Capistrano 3.4.0, Unicorn e Foreman na Gemfile:	source 'https://rubygems.org'


								# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
								gem 'rails', '4.2.4'
								# Use postgresql as the database for Active Record
								gem 'pg'
								# Use SCSS for stylesheets
								gem 'sass-rails', '~> 5.0'
								# Use Uglifier as compressor for JavaScript assets
								gem 'uglifier', '>= 1.3.0'
								# Use CoffeeScript for .coffee assets and views
								gem 'coffee-rails', '~> 4.1.0'
								# See https://github.com/rails/execjs#readme for more supported runtimes
								# gem 'therubyracer', platforms: :ruby
								# Use jquery as the JavaScript library
								gem 'jquery-rails'
								# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
								gem 'turbolinks'
								# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
								gem 'jbuilder', '~> 2.0'
								# bundle exec rake doc:rails generates the API under doc/api.
								gem 'sdoc', '~> 0.4.0', group: :doc

								# Use ActiveModel has_secure_password
								# gem 'bcrypt', '~> 3.1.7'
								# Use Unicorn as the app server
								gem 'unicorn'

								gem 'foreman', '~> 0.78.0'
								# Use Capistrano for deployment
								# gem 'capistrano-rails', group: :development

								group :development, :test do
								  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
								  gem 'byebug'
								  # Access an IRB console on exception pages or by using <%= console %> in views
								  gem 'web-console', '~> 2.0'
								  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
								  gem 'spring'
								end
								group :development do
								  gem 'capistrano', '~> 3.4.0'
								  gem 'capistrano-bundler', '~> 1.1.4'
								  gem 'capistrano-rails', '~> 1.1.3'
								  # Add this if you're using rvm
								  gem 'capistrano-rvm', github: "capistrano/rvm"
								end





Run: bundle --binstubs
     cap install STAGES=production





Adicionar ao Capfile:	# Load DSL and set up stages
			require 'capistrano/setup'
			# Include default deployment tasks
			require 'capistrano/deploy'

			# Include tasks from other gems included in your Gemfile
			#
			# For documentation on these, see for example:
			#
			#   https://github.com/capistrano/rvm
			#   https://github.com/capistrano/rbenv
			#   https://github.com/capistrano/chruby
			#   https://github.com/capistrano/bundler
			#   https://github.com/capistrano/rails
			#   https://github.com/capistrano/passenger
			#
			require 'capistrano/rvm'
			set :rvm_type, :user
			set :rvm_ruby_version, '2.2.3-p173'
			# require 'capistrano/rbenv'
			# require 'capistrano/chruby'
			require 'capistrano/rails'
			require 'capistrano/bundler'
			require 'capistrano/rails/assets'
			# require 'capistrano/rails/migrations'
			# require 'capistrano/passenger'

			# Load custom tasks from `lib/capistrano/tasks` if you have any defined
			Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }





Adicionar ao deploy.rb: # config valid only for current version of Capistrano
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
		              sudo "ln -nfs /home/deploy/apps/foreman4rails/current/config/nginx.conf /etc/nginx/sites-enabled/foreman4rails"
		              sudo "ln -nfs /home/deploy/apps/foreman4rails/current/config/unicorn_ini.sh /etc/init.d/unicorn_foreman4rails"
		              execute "chmod +x /etc/init.d/unicorn_foreman4rails"
		              put File.read("config/database.yml"), "#home/deploy/apps/foreman4rails/shared/config/database.yml"
		              puts "Now edit the config files in #{shared_path}."
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
			        execute "sudo chmod -R 1777 /etc/init/"
			        execute "foreman export upstart /etc/init --app=#{fetch(:application)} --user=#{fetch(:user)}"
			    end
			  end

			  desc "Start the application services"
			  task :start do
			    on roles(:app) do
			        execute "service start foreman4rails"
			    end
			  end

			  desc "Stop the application services"
			  task :stop do
			    on roles(:app) do
			        execute "service stop foreman4rails"
			    end
			  end

			  desc "Restart the application services"
			  task :restart do
			    on roles(:app) do
			        execute "service start foreman4rails || service restart foreman4rails"
			    end
			  end
			end

			after "deploy:publishing", "foreman:export"
			after "deploy:publishing", "foreman:restart"





Adicionar ao production.rb: set :stage, :production
			    set :rails_env, 'production'

			    # Replace 127.0.0.1 with your server's IP address!
			    server '127.0.0.1', user: 'deploy', roles: %w{web app db}





Criar nginx.conf na pasta config e adiconar o conteúdo:	upstream unicorn {
							server unix:/tmp/unicorn.foreman4rails.sock fail_timeout=0;
							}

							server {
							  listen 80 default deferred;
							  server_name Foreman4Rails;
							  if ($host = 'Foreman4Rails' ) {
							    rewrite ^/(.*)$ http://Foreman4Rails/$1 permanent;
							  }
							  root /home/deploy/apps/foreman4rails/current/public;

							  location ^~ /assets/ {
							    gzip_static on;
							    expires max;
							    add_header Cache-Control public;
							  }

							  try_files $uri/index.html $uri @unicorn;

							  location @unicorn {
							    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
							    proxy_set_header Host $http_host;
							    proxy_redirect off;
							    proxy_pass http://unicorn;
							  }

							  error_page 500 502 503 504 /500.html;
							  client_max_body_size 4G;
							  keepalive_timeout 10;
							}





Criar unicorn.conf na pasta config e adiconar o conteúdo:	# Define your root directory
								root = "/home/deploy/apps/foreman4rails/current"

								# Define worker directory for Unicorn
								working_directory root

								# Location of PID file
								pid "#{root}/tmp/pids/unicorn.pid"

								# Define Log paths
								stderr_path "#{root}/log/unicorn.log"
								stdout_path "#{root}/log/unicorn.log"

								# Listen on a UNIX data socket
								listen "/tmp/unicorn.foreman4rails.sock"

								# 16 worker processes for production environment
								worker_processes 16

								# Load rails before forking workers for better worker spawn time
								preload_app true

								# Restart workes hangin' out for more than 240 secs
								timeout 240





Criar unicorn_ini.sh na pasta config e adiconar o conteúdo:	#!/bin/sh
								### BEGIN INIT INFO
								# Provides:          unicorn
								# Required-Start:    $remote_fs $syslog
								# Required-Stop:     $remote_fs $syslog
								# Default-Start:     2 3 4 5
								# Default-Stop:      0 1 6
								# Short-Description: Manage unicorn server
								# Description:       Start, stop, restart unicorn server for a specific application.
								### END INIT INFO
								set -e

								# Feel free to change any of the following variables for your app:
								TIMEOUT=${TIMEOUT-60}
								APP_ROOT=/home/deploy/apps/foreman4rails/current
								PID=$APP_ROOT/tmp/pids/unicorn.pid
								CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E production"
								AS_USER=deploy
								set -u

								OLD_PIN="$PID.oldbin"

								sig () {
								  test -s "$PID" && kill -$1 `cat $PID`
								}

								oldsig () {
								  test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
								}

								run () {
								  if [ "$(id -un)" = "$AS_USER" ]; then
								    eval $1
								  else
								    su -c "$1" - $AS_USER
								  fi
								}

								case "$1" in
								start)
								  sig 0 && echo >&2 "Already running" && exit 0
								  run "$CMD"
								  ;;
								stop)
								  sig QUIT && exit 0
								  echo >&2 "Not running"
								  ;;
								force-stop)
								  sig TERM && exit 0
								  echo >&2 "Not running"
								  ;;
								restart|reload)
								  sig HUP && echo reloaded OK && exit 0
								  echo >&2 "Couldn't reload, starting '$CMD' instead"
								  run "$CMD"
								  ;;
								upgrade)
								  if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
								  then
								    n=$TIMEOUT
								    while test -s $OLD_PIN && test $n -ge 0
								    do
								      printf '.' && sleep 1 && n=$(( $n - 1 ))
								    done
								    echo

								    if test $n -lt 0 && test -s $OLD_PIN
								    then
								      echo >&2 "$OLD_PIN still exists after $TIMEOUT seconds"
								      exit 1
								    fi
								    exit 0
								  fi
								  echo >&2 "Couldn't upgrade, starting '$CMD' instead"
								  run "$CMD"
								  ;;
								reopen-logs)
								  sig USR1
								  ;;
								*)
								  echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
								  exit 1
								  ;;
								esac





Adicionar a routes.rb: Rails.application.routes.draw do
  			 resources :users
  			 root to: "users#index"
  		       end





Criar Procfile e adicionar: web: bundle exec unicorn -E production -c /home/deploy/apps/foreman4rails/current/config/unicorn.rb





Gerar scaffold: rails g scaffold Users name email





GitHub: git init
	git add .
	git commit -m ""
	git remote add origin git@github.com:dev9seucondominio/foreman4rails.git
	git push -u origin master





Adicionar SSH-KEY: ssh-copy-id root@IPADDRESS
                   ssh-copy-id deploy@IPADDRESS





Deploy para o servidor: cap production deploy





Deploy migrate para o servidor: cap production deploy:migrate


*********************************************************************************
*  *****************************'***************'*****************************  *
* *'*'**'*':**'*'**'*':**'*'**'*'S E R V I D O R'*'**'*':**'*'**'*':**'*'**'*'* *
*  *****************************'***************'*****************************  *
*********************************************************************************

Adicionar usuário ao servidor: sudo adduser deploy
			       sudo adduser deploy sudo
			       su deploy

***if "perl: warning: Setting locale failed."

       run "sudo nano /var/lib/locales/supported.d/local"
       add "en_US.UTF-8 UTF-8
            en_US ISO-8859-1
            pt_BR ISO-8859-1
            pt_BR.UTF-8 UTF-8"
       run "sudo dpkg-reconfigure locales"

***end


Instalar Ruby 2.2.3: sudo apt-get update
		     sudo apt-get install -y libgmp3-dev
		     sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev





Instalar RVM: sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
	      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
              curl -L https://get.rvm.io | bash -s stable
	      source ~/.rvm/scripts/rvm
	      rvm install 2.2.3
              rvm use 2.2.3 --default
 	      ruby -v





Instalar Bundler gem: echo "gem: --no-ri --no-rdoc" > ~/.gemrc
		      gem install bundler





Instalar PostgreSQL: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
		     wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
		     sudo apt-key add -
		     sudo apt-get update
		     sudo apt-get install postgresql-common
		     sudo apt-get install postgresql-9.4 postgresql-contrib libpq-dev
		     psql -V





Criar usuario postgres: sudo su - postgres
			createuser --pwprompt
			exit





Criar arquivo database.yml em shared/config/: production:
  						adapter: postgresql
 						database: foreman4rails
 						username: deploy
  						password: 1234





Criar arquivo secrets.yml em shared/config/: production:
  					       secret_key_base: "GERAR KEY USANDO 'RAKE SECRET' EM ***MACHINE***"





Criar Database: sudo su
		su postgres
		psql
		create database foreman4rails with owner = deploy;
		\q
		exit
		exit
		psql --user deploy --password foreman4rails
		\q





Instalar gem Foreman: gem install foreman
		      bundle install





Configurar Unicorn: sudo ln -nfs /home/deploy/apps/foreman4rails/current/config/nginx.conf /etc/nginx/sites-enabled/foreman4rails
		    sudo ln -nfs /home/deploy/apps/foreman4rails/current/config/unicorn_ini.sh /etc/init.d/unicorn_foreman4rails
		    chmod +x /etc/init.d/unicorn_foreman4rails





Iniciar Foreman: foreman start
