web: bundle exec unicorn -E production -c /home/deploy/apps/foreman4rails/current/config/unicorn_production.rb -l /home/deploy/apps/foreman4rails/current/log/production.log
worker: bundle exec sidekiq -e production -l /home/deploy/apps/foreman4rails/current/log/production.log