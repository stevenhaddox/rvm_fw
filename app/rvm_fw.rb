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
  set :logging, true

  before do
    # TODO: Change $VERBOSE to only set to nil in production environments
    $VERBOSE = nil # Quiet warnings on duplicate initialization of constants

    #app variables
    IGNORED_FILES        ||= ENV['IGNORED_FILES'] || ['.','..','.DS_Store','.git','.svn']
    APP_ROOT             ||= ENV['APP_ROOT']      || File.expand_path('../..', __FILE__)
    RUBIES_PATH          ||= ENV['RUBIES_PATH']   || File.expand_path('../../public/rubies', __FILE__)
    RVM_VERSION          ||= ENV['RVM_VERSION']
    CHRUBY_VERSION       ||= ENV['CHRUBY_VERSION']
    RUBY_INSTALL_VERSION ||= ENV['RUBY_INSTALL_VERSION']
    RBENV_VERSION        ||= ENV['RBENV_VERSION']
    RUBY_BUILD_VERSION   ||= ENV['RUBY_BUILD_VERSION']
    if ENV['HOST']
      HOST ||= ENV['HOST']
    else
      HOST = "#{request.scheme}://#{request.host}"
      HOST += ":#{request.port}" unless [80, 443].include?(request.port)
    end
    logger.info("HOST: #{HOST}")
    RVM_HOST ||= ENV['RVM_HOST'].nil? ? HOST : ENV['RVM_HOST']
    logger.info("RVM_HOST: #{RVM_HOST}")
  end

  get '/' do
    logger.info("GET /")
    haml :index
  end

  get '/install' do
    logger.info("GET /install")
    content_type 'text/plain', :charset => 'utf-8'
    erb :installer
  end

  get '/db' do
    logger.info("GET /db")
    content_type 'text/plain', :charset => 'utf-8'
    erb :db
  end

  get '/known' do
    logger.info("GET /known")
    content_type 'text/plain', :charset => 'utf-8'
    erb :known
  end

  get '/packages' do
    logger.info("GET /packages")
    content_type 'text/plain', :charset => 'utf-8'
    erb :packages
  end

  get '/rubies/*' do
    file_path = params['splat'].is_a?(Array) ? params['splat'][0] : params['splat']
    logger.info("GET /rubies/*, file_path: #{file_path}")

    # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
    if File.exist?("#{RUBIES_PATH}/#{file_path}")
      file = File.join(RUBIES_PATH, file_path) # => ["filename.ext"]
      send_file(file, :disposition => 'attachment', :filename => File.basename(file))
    else
      halt 404
    end
  end

  not_found do
    logger.error("Not Found 404")
    haml :error_404
  end

  get '/files' do
    logger.info("GET /files")
    @rubies = Dir.glob('public/rubies/**/*.[a-zA-Z]*')
    @rubies = @rubies.map{ |ruby| ruby unless ruby =~ /pre(.)$/}
    @rubies = @rubies.compact if @rubies.include?(nil)
    haml :files
  end

  get '/releases/rvm-install-latest' do
    logger.info("GET /releases/rvm-install-latest")
    content_type 'text/plain', :charset => 'utf-8'
    erb :rvm_install
  end

  get '/releases/stable-version.txt' do
    logger.info("GET /releases/stable-version.txt")
    content_type 'text/plain', :charset => 'utf-8'
    RVM_VERSION
  end

  get '/openssl/haxx.cacert.pem' do
    logger.info("GET /openssl/haxx.cacert.pem")
    content_type 'text/plain', :charset => 'utf-8'
    send_file 'views/haxx.cacert.pem'
  end

  get '/md5' do
    logger.info("GET /md5")
    content_type 'text/plain', :charset => 'utf-8'
    "I'll eventually return a customized ~/.rvm/config/md5 file if it is needed..."
  end

  get '/chruby' do
    logger.info("GET /chruby")
    haml :chruby
  end

  get '/rbenv' do
    logger.info("GET /rbenv")
    haml :rbenv
  end

  get '/credits' do
    logger.info("GET /credits")
    haml :credits
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
