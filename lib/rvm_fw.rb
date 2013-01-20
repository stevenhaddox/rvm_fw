require 'sinatra/base'

class RvmFw < Sinatra::Base
  # rvm_fw main application
  require "rubygems"
  require "bundler/setup"

  require 'sinatra'
  require 'fileutils'
  require 'digest/md5'
  require 'yaml'

  set :views, File.expand_path('../../views', __FILE__)

  before do
    #app variables
    IGNORED_FILES = ['.','..','.DS_Store','.git','.svn'] unless defined?(IGNORED_FILES)
    APP_ROOT      = File.expand_path('../..', __FILE__) unless defined?(APP_ROOT)
    RUBIES_PATH   = File.expand_path('../../public/rubies', __FILE__) unless defined?(RUBIES_PATH)
    RVM_VERSION   = '1.17.9' unless defined?(RVM_VERSION)
    unless defined?(HOST)
      HOST          = "#{request.scheme}://#{request.host}" 
      HOST          += ":#{request.port}" unless [80, 443].include?(request.port) 
    end
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

  get '/known' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :known
  end

  get '/rubies/*' do
    file_path = params['splat'].is_a?(Array) ? params['splat'][0] : params['splat']
    # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
    if File.exist?("#{RUBIES_PATH}/#{file_path}")
      file = File.join(RUBIES_PATH, file_path) # => ["filename.ext"]
      send_file(file, :disposition => 'attachment', :filename => File.basename(file))
    else 
      halt 404
    end
  end

  not_found do
    haml :error_404
  end

  get '/files' do
    # See if we have a custom rubies.yml file, if not use the .example default.
    if File.exist? File.expand_path("../../config/rubies.yml", __FILE__)
      rubies_yaml_file = File.expand_path("../../config/rubies.yml", __FILE__)
    else
      rubies_yaml_file = File.expand_path("../../config/rubies.yml.example", __FILE__)
    end

    @rubies = YAML::load_file(rubies_yaml_file)
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
