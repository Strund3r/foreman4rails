namespace :foreman do

  processes = [ { process: "web", concurrency: 1 },
                { process: "worker", concurrency: 1 }]

  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do

        processes.collect do |process|
          begin
            debug "Stopping service #{fetch(:application)}-#{process[:process]}"
            execute :sudo, "service #{fetch(:application)}-#{process[:process]} stop"
          rescue Exception => e
            debug "#{fetch(:application)}-#{process[:process]} is already stopped"
          end
        end

        execute :sudo, "rm -rf /etc/init/#{fetch(:application)}*"
        execute "/home/deploy/.rvm/bin/rvm all do foreman export upstart /etc/init -f /home/deploy/apps/foreman4rails/current/Procfile -t foreman/export/my_upstart -a #{fetch(:application)} -u #{fetch(:user)} -l #{current_path}/log -c #{!ENV['concurrency'].nil? ? ENV['concurrency'] : "#{processes.map{ |p| "#{p[:process]}=#{p[:concurrency]}"}.join(",")}"}"

      end
    end
  end

  desc "Show processes statuses"
  task :statuses do
    on roles(:app) do
      within current_path do
        processes.collect do |process|
          begin
            execute :sudo, "service #{fetch(:application)}-#{process[:process]} status"
          rescue Exception => e
            debug "#{e.message}"
          end
        end
      end
    end
  end

  desc "Start single service or all of them"
  task :start do
    on roles(:web) do
      execute :sudo, "service #{!ENV['process'].nil? ? "#{fetch(:application)}-#{ENV['process']}" : fetch(:application)} start"
    end
  end

  desc "Stop single service or all of them"
  task :stop do
    on roles(:web) do
      execute :sudo, "service #{!ENV['process'].nil? ? "#{fetch(:application)}-#{ENV['process']}" : fetch(:application)} stop"
    end
  end

  desc "Restart single service or all of them"
  task :restart do
    on roles(:web) do
      execute :sudo, "service #{!ENV['process'].nil? ? "#{fetch(:application)}-#{ENV['process']}" : fetch(:application)} restart"
    end
  end

end