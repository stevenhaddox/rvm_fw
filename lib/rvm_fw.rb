require 'sinatra/base'

class RvmFw < Sinatra::Base
  # rvm_fw main application
  require "rubygems"
  require "bundler/setup"

  require 'sinatra'
  require 'fileutils'
  require 'digest/md5'
  require 'yaml'

  before do
    #app variables
    IGNORED_FILES ||= ['.','..','.DS_Store','.git','.svn']
    APP_ROOT      ||= File.join(Dir.pwd)
    RUBIES_PATH   ||= File.join(APP_ROOT,'/public/rubies')
    RVM_VERSION   ||= '1.6.2'
    HOST          = "#{request.scheme}://#{request.host}"
    HOST          += ":#{request.port}" unless [80, 443].include?(request.port)
  end

  # CSS path_prefixs
  get '/stylesheets/application.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :application, :style => :expanded
  end

  get '/' do
    haml :index
  end

  get '/db' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :db
  end

  get '/rubies/*' do
    # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
    if File.exist?("public/rubies/#{params['splat']}")
      file = File.join(@RUBIES_PATH, params["splat"]) # => ["filename.ext"]
      send_file(file, :disposition => 'attachment', :filename => File.basename(file))
    else 
      halt 404
    end
  end

  not_found do
    haml :error_404
  end

  get '/files' do
    @rubies = YAML::load_file('config/rubies.yml')
    haml :files
  end

  get '/releases/rvm-install-latest' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :rvm_install
  end

  get '/releases/stable-version.txt' do
    content_type 'text/plain', :charset => 'utf-8'
    RVM_VERSION
  end

  get '/md5' do
    content_type 'text/plain', :charset => 'utf-8'
    "I'll eventually return a customized ~/.rvm/config/md5 file if it is needed..."
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
