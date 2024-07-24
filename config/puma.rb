environment ENV['RAILS_ENV'] || 'development'

if Gem.win_platform?
  workers 0
else
  workers ENV.fetch('WEB_CONCURRENCY') { 2 }
end

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

preload_app!

port ENV['PORT'] || 3001

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
