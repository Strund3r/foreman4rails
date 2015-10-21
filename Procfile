web: bundle exec unicorn -p $PORT -E production -c /home/deploy/apps/foreman4rails/current/config/unicorn_production.rb --no-default-middleware
worker: bundle exec sidekiq -e production