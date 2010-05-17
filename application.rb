# rvm_fw main application
require 'rubygems'
require 'sinatra'
require 'FileUtils'
require 'digest/md5'

before do
  #app variables
  IGNORED_FILES = ['.','..','.DS_Store','.git','.svn']
  APP_ROOT = File.join(Dir.pwd)
  RUBIES_PATH = File.join(APP_ROOT,'/public/rubies')
end

# CSS path_prefixs
get '/stylesheets/application.css' do
  content_type 'text/css', :charset => 'utf-8'
  less :application
end

get '/' do
  haml :index
end

get '/db' do
  content_type 'text/plain', :charset => 'utf-8'
  File.read(APP_ROOT+"/views/db.txt")
end

get '/md5' do
  content_type 'text/plain', :charset => 'utf-8'
  "I'll eventually return a customized ~/.rvm/config/md5 file if it is needed..."
end

get '/rubies/*' do
  # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
  file = File.join(@RUBIES_PATH, params["splat"]) # => ["filename.ext"]
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

not_found do
  haml :error_404
end

get '/files' do
  @rubies = {
      "ironruby-1.0.zip" => {
        :md5 => "7a92888837b3507355ed391dbfc0ab83",
        :path_prefix => nil
      },
      "jruby-bin-1.4.0.tar.gz" => {
        :md5 => "f37322c18e9134e91e064aebb4baa4c7",
        :path_prefix => "jruby/1.4.0/"
      },
      "jruby-bin-1.5.0.RC1.tar.gz" => {
        :md5 => "47b4ca2a21659d36a2775ade0a2534c4",
        :path_prefix => "jruby/1.5.0/"
      },
      "macruby_nightly-latest.pkg" => {
        :md5 => "88327b5f4c5b4041a2f5e0f51e769bff",
        :path_prefix => nil
      },
      "MacRuby 0.5.zip" => {
        :md5 => "675454a8c7bc19d606d90a726e08427c",
        :path_prefix => nil
      },
      "MagLev-23275-0.tar.gz" => {
        :md5 => "7591f9f3931f1a352f40e61834c6a063",
        :path_prefix => nil
      },
      "rubinius-1.0.0-20100514.tar.gz" => {
        :md5 => "b05f4e791d3712c5a50b3d210dac6eb0",
        :path_prefix => nil
      },
      "ruby-1.8.5-p231.tar.gz" => {
        :md5 => "e900cf225d55414bffe878f00a85807c",
        :path_prefix => nil
      },
      "ruby-1.8.6-p399.tar.gz" => {
        :md5 => "c3d16cdd3c1ee8f3b7d1c399d4884e33",
        :path_prefix => nil
      },
      "ruby-1.8.7-p249.tar.gz" => {
        :md5 => "d7db7763cffad279952eb7e9bbfc221c",
        :path_prefix => nil
      },
      "ruby-1.9.1-p378.tar.gz" => {
        :md5 => "9fc5941bda150ac0a33b299e1e53654c",
        :path_prefix => nil
      },
      "ruby-1.9.2-preview1.tar.gz" => {
        :md5 => "e2b8cdbf300f53472be09699a5837fd1",
        :path_prefix => nil
      },
      "ruby-enterprise-1.8.6-20090610.tar.gz" => {
        :md5 => "0bf66ee626918464a6eccdd83c99d63a",
        :path_prefix => nil
      },
      "ruby-enterprise-1.8.7-2010.01.tar.gz" => {
        :md5 => "587aaea02c86ddbb87394a340a25e554",
        :path_prefix => nil
      },
      "rubygems-1.3.5.tgz" => {
        :md5 => "6e317335898e73beab15623cdd5f8cff",
        :path_prefix => nil
      },
      "rubygems-1.3.6.tgz" => {
        :md5 => "789ca8e9ad1d4d3fe5f0534fcc038a0d",
        :path_prefix => nil
      }
    }
  
  haml :files
end


# External download path_prefixs
################################################
#jruby
#jruby_url + '/1.4.0/jruby-bin-1.4.0.tar.gz'
