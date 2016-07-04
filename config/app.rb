require 'rubygems'
require 'bundler/setup'

require 'active_support/all'
require 'ostruct'
require 'resque'

require 'sinatra'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

configure do
  set :root, APP_ROOT.to_path
  set :server, :puma
end


# GitHub account and branches
GITHUB_ACC    = "func-i"
GITHUB_REPO   = "fi-site-source"
GITHUB_URL    = "https://github.com/#{GITHUB_ACC}/#{GITHUB_REPO}.git"
GH_STAGING    = "staging"
GH_PRODUCTION = "master"
GH_DEMO       = "demo"

# temp folders on Heroku
TEMP_DIR = "/tmp"
CODE_DIR = "#{TEMP_DIR}/code"
SITE_DIR = "#{TEMP_DIR}/site"

require APP_ROOT.join('app', 'build_queue')
require APP_ROOT.join('app', 'handler')
require APP_ROOT.join('app', 'router')
