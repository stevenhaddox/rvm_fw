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
  MD5_HASHES = {
    "ironruby-1.0.zip"                      => "7a92888837b3507355ed391dbfc0ab83",
    "jruby-bin-1.4.0.tar.gz"                => "f37322c18e9134e91e064aebb4baa4c7",
    "jruby-bin-1.5.0.RC1.tar.gz"            => "47b4ca2a21659d36a2775ade0a2534c4",
    "macruby_nightly-latest.pkg"            => "88327b5f4c5b4041a2f5e0f51e769bff",
    "MacRuby 0.5.zip"                       => "675454a8c7bc19d606d90a726e08427c",
    "MagLev-23275-0.tar.gz"                 => "7591f9f3931f1a352f40e61834c6a063",
    "rubinius-1.0.0-rc3-20100216.tar.gz"    => "c72d060c574cd1214ec3a9560a64c4fe",
    "rubinius-1.0.0-rc4-20100331.tar.gz"    => "7daac881eb5916458a60affe16bcfbbf",
    "ruby-1.8.5-p231.tar.gz"                => "e900cf225d55414bffe878f00a85807c",
    "ruby-1.8.6-p399.tar.gz"                => "c3d16cdd3c1ee8f3b7d1c399d4884e33",
    "ruby-1.8.7-p249.tar.gz"                => "d7db7763cffad279952eb7e9bbfc221c",
    "ruby-1.9.1-p378.tar.gz"                => "9fc5941bda150ac0a33b299e1e53654c",
    "ruby-1.9.2-preview1.tar.gz"            => "e2b8cdbf300f53472be09699a5837fd1",
    "ruby-enterprise-1.8.6-20090610.tar.gz" => "0bf66ee626918464a6eccdd83c99d63a",
    "ruby-enterprise-1.8.7-2010.01.tar.gz"  => "587aaea02c86ddbb87394a340a25e554",
    "rubygems-1.3.5.tgz"                    => "6e317335898e73beab15623cdd5f8cff",
    "rubygems-1.3.6.tgz"                    => "789ca8e9ad1d4d3fe5f0534fcc038a0d"
  }
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
  content_type 'text/html', :charset => 'utf-8'
  "I'll eventually return a customized ~/.rvm/config/user file"
end

get '/files' do
  @rubies = []
  Dir.entries(RUBIES_PATH).each do |file|
    next if IGNORED_FILES.include?(file)
    @rubies << {:name => File.basename(file), :md5 => Digest::MD5.hexdigest(File.read("#{RUBIES_PATH}/#{file}"))}
  end
  haml :files
end

get '/rubies/*' do
  # matches /rubies/filename.tar.gz, /rubies/filename.zip, etc.
  file = File.join(@RUBIES_PATH, params["splat"]) # => ["filename.ext"]
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

not_found do
  haml :error_404
end