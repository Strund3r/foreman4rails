web: bundle exec unicorn -p $PORT -c /home/deploy/apps/foreman4rails/current/config/unicorn_production.rb --no-default-middleware
worker: bundle exec sidekiq -e production