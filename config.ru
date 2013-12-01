require 'rubygems'
require 'bundler'
Bundler.setup

# Only require rubygems/deprecate if your RubyGems version needs it
# If you do not get the Gem::Deprecate error you can leave it commented out
# require 'rubygems/deprecate'

require File.join(File.dirname(__FILE__), 'app/rvm_fw.rb')
run RvmFw
