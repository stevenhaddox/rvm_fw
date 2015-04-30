require "rubygems"
require "bundler/setup"

require 'dotenv'
Dotenv.load
require 'sinatra'
require 'fileutils'
require 'digest/md5'
require 'yaml'
require 'haml'

class RvmFw < Sinatra::Base
  set :root, File.expand_path('../',File.dirname(__FILE__))

  before do
    #app variables
    IGNORED_FILES ||= ENV['IGNORED_FILES'] || ['.','..','.DS_Store','.git','.svn']
    APP_ROOT      ||= ENV['APP_ROOT']      || File.expand_path('../..', __FILE__)
    RUBIES_PATH   ||= ENV['RUBIES_PATH']   || File.expand_path('../../public/rubies', __FILE__)
    RVM_VERSION   ||= ENV['RVM_VERSION']   || '1.18.14'
    if ENV['HOST']
      HOST ||= ENV['HOST']
    else
      HOST = "#{request.scheme}://#{request.host}"
      HOST += ":#{request.port}" unless [80, 443].include?(request.port)
    end
    RVM_HOST ||= ENV['RVM_HOST'].nil? ? HOST : ENV['RVM_HOST']
  end

  get '/' do
    haml :index
  end

  get '/install' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :installer
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
    @rubies = Dir.glob('public/rubies/**/*.[a-zA-Z]*')
    @rubies = @rubies.map{ |ruby| ruby unless ruby =~ /pre(.)$/}
    @rubies = @rubies.compact if @rubies.include?(nil)
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

  get '/openssl/haxx.cacert.pem' do
    content_type 'text/plain', :charset => 'utf-8'
    send_file 'views/haxx.cacert.pem'
  end

  get '/md5' do
    content_type 'text/plain', :charset => 'utf-8'
    "I'll eventually return a customized ~/.rvm/config/md5 file if it is needed..."
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
