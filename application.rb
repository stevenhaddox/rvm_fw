# hello_world.rb
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
  # matches /download/path/to/file.tgz
  file = File.join(Dir.pwd, '/rubies', params["splat"]) # => ["filename.ext"]
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end
