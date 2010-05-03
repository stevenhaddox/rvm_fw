# This file goes in domain.com/config.ru
require 'rubygems'
require 'sinatra'
require 'less'

set :env,  :development #:production
disable :run

require 'application'

run Sinatra::Application