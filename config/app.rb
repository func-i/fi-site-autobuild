require 'rubygems'
require 'bundler/setup'

require 'active_support/all'
require 'ostruct'

require 'sinatra'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

configure do
  set :root, APP_ROOT.to_path
  set :server, :puma
end

require APP_ROOT.join('app', 'handler')
require APP_ROOT.join('app', 'router')
