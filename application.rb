# hello_world.rb
require 'rubygems'
require 'sinatra'

# CSS paths
get '/print.css' do
  content_type 'text/css', :charset => 'utf-8'
  
end

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


get '/rubies/*.*' do
  # matches /download/path/to/file.tgz
  params["splat"] # => ["path/to/file", "tgz"]
  "I'll eventually look for and download: filename"
end