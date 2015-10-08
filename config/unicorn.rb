# Define your root directory
root = "/home/deploy/apps/foreman4rails/current"

# Define worker directory for Unicorn
working_directory = "/home/deploy/apps/foreman4rails/current"

# Location of PID file
pid "#{root}/tmp/pids/unicorn.pid"

# Define Log paths
stderr_path "#{root}/log/unicorn-err.log"
stdout_path "#{root}/log/unicorn-out.log"

# Listen on a UNIX data socket
listen "/tmp/unicorn.foreman4rails.sock"

# 16 worker processes for production environment
worker_processes 16

# Load rails before forking workers for better worker spawn time
preload_app true

# Restart workes hangin' out for more than 240 secs
timeout 240