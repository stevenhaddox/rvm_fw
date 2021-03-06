# Generated by cucumber-sinatra. (2012-04-30 07:36:14 -0400)
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV['RACK_ENV'] = 'test'
ENV['CHRUBY_VERSION'] = '0.3.9'
ENV['RUBY_INSTALL_VERSION'] = '0.5.0'
ENV['RBENV_VERSION'] = '5b9e4f05846f6bd03b09b8572142f53fd7a46e62'
ENV['RUBY_BUILD_VERSION'] = 'e932d47195d76d6be9635a012056069e794039e0'

require File.join(File.dirname(__FILE__), '..', '..', 'app/rvm_fw.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = RvmFw

class RvmFwWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  RvmFwWorld.new
end
