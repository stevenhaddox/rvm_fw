# rvm_fw main application
require 'rubygems'
require 'sinatra'

before do
  #app variables
  @APP_ROOT = File.join(Dir.pwd)
  @RUBIES_PATH = File.join(@APP_ROOT,'/public/rubies')
  @IGNORED_FILES = ['.','..','.DS_Store']
end

# CSS paths
get '/stylesheets/application.css' do
  content_type 'text/css', :charset => 'utf-8'
  less :application
end

get '/' do
  haml :index
end

get '/db' do
  "I'll eventually return a ~/.rvm/config/db syntax file..."
end

get '/files' do
  haml :files
end

get '/rubies/*' do
  # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
  file = File.join(@RUBIES_PATH, params["splat"]) # => ["filename.ext"]
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end
