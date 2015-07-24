require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.dirname(__FILE__) + "/../app/rvm_fw.rb"
require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

RSpec.configure do |conf|
    conf.include Rack::Test::Methods
end
