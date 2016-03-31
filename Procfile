web: bundle exec puma -C config/puma.rb
worker: env INTERVAL=1 QUEUE=auto_build bundle exec rake resque:work
