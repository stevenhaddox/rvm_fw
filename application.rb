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
        :path_prefix => "ironruby/"
      },
      "jruby-bin-1.4.0.tar.gz" => {
        :md5 => "f37322c18e9134e91e064aebb4baa4c7",
        :path_prefix => "jruby/1.4.0/"
      },
      "jruby-bin-1.5.0.tar.gz" => {
        :md5 => "fd5c0fa9e42cf499807711a8d98d5402",
        :path_prefix => "jruby/1.5.0/"
      },
      "jruby-bin-1.5.1.tar.gz" => {
        :md5 => "74251383e08e8c339cacc35a7900d3af",
        :path_prefix => "jruby/1.5.1/"
      },
      "macruby_nightly-latest.pkg" => {
        :md5 => "88327b5f4c5b4041a2f5e0f51e769bff",
        :path_prefix => "macruby/"
      },
      "MacRuby 0.6.zip" => {
        :md5 => "a80afd3700c88cf95c539fc63b272faf",
        :path_prefix => "macruby/"
      },
      "MagLev-23577-0.tar.gz" => {
        :md5 => "",
        :path_prefix => "maglev/"
      },
      "rubinius-1.0.0-20100514.tar.gz" => {
        :md5 => "b05f4e791d3712c5a50b3d210dac6eb0",
        :path_prefix => "rubinius/"
      },
      "ruby-1.8.5-p231.tar.gz" => {
        :md5 => "e900cf225d55414bffe878f00a85807c",
        :path_prefix => "ruby-lang/1.8/"
      },
      "ruby-1.8.6-p399.tar.gz" => {
        :md5 => "c3d16cdd3c1ee8f3b7d1c399d4884e33",
        :path_prefix => "ruby-lang/1.8/"
      },
      "ruby-1.8.7-p249.tar.gz" => {
        :md5 => "d7db7763cffad279952eb7e9bbfc221c",
        :path_prefix => "ruby-lang/1.8/"
      },
      "ruby-1.8.7-p174.tar.gz" => {
        :md5 => "18dcdfef761a745ac7da45b61776afa5",
        :path_prefix => "ruby-lang/1.8/"
      },
      "ruby-1.9.1-p378.tar.gz" => {
        :md5 => "9fc5941bda150ac0a33b299e1e53654c",
        :path_prefix => "ruby-lang/1.9/"
      },
      "ruby-1.9.2-preview3.tar.gz" => {
        :md5 => "209e59f3495a5503fa948c2732f1d705",
        :path_prefix => "ruby-lang/1.9/"
      },
      "ruby-enterprise-1.8.6-20090610.tar.gz" => {
        :md5 => "0bf66ee626918464a6eccdd83c99d63a",
        :path_prefix => "ree/"
      },
      "ruby-enterprise-1.8.7-2010.02.tar.gz" => {
        :md5 => "9ba45629396071d7faf172279af4298b",
        :path_prefix => "ree/"
      },
      "rubygems-1.3.5.tgz" => {
        :md5 => "6e317335898e73beab15623cdd5f8cff",
        :path_prefix => "rubygems/"
      },
      "rubygems-1.3.6.tgz" => {
        :md5 => "789ca8e9ad1d4d3fe5f0534fcc038a0d",
        :path_prefix => "rubygems/"
      },
      "rubygems-1.3.7.tgz" => {
        :md5 => "e85cfadd025ff6ab689375adbf344bbe",
        :path_prefix => "rubygems/"
      }
    }
  
  haml :files
end


