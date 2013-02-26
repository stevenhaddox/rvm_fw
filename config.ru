require 'rubygems'
# Only require rubygems/deprecate if your RubyGems version needs it
# If you do not get the Gem::Deprecate error you can leave it commented out
# require 'rubygems/deprecate'
require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), 'app/rvm_fw.rb')
run RvmFw
