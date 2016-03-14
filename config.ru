# Require config/app.rb
require ::File.expand_path('../config/app',  __FILE__)

run Sinatra::Application
