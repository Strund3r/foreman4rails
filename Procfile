web: bundle exec unicorn -E production -c /home/deploy/apps/foreman4rails/current/config/unicorn_production.rb -l /var/log/upstart/foreman4rails-web-1.log
worker: bundle exec sidekiq -e production