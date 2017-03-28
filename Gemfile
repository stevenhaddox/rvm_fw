source 'http://rubygems.org'
gem 'dotenv', '~> 2.0'
gem 'haml', '~> 3.1.8' # < 4.0 for Ruby 1.8.7
gem 'json', '~>1.8.0'
gem 'rake', '~> 10.0'
gem 'sinatra', :require => 'sinatra/base'
gem 'rack'

# Important compatibility versions
gem 'tilt', '~> 1.4.1'
gem 'mime-types', '~> 1.25.1'
gem 'nokogiri', '~> 1.5.11'

group :development do
  gem 'bootstrap-sass', '~> 3.3.4'
  gem 'compass', '~> 0.12'
  gem 'foreman'
  gem 'travis-lint'
end

group :test do
  gem 'capybara', '~> 2.0.3' # Ruby < 1.9.3 compatible
  gem 'codeclimate-test-reporter', :require => nil
  gem 'cucumber-sinatra'
  gem 'cucumber'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubyzip', '~> 0.9.9' # Ruby < 1.9.3 compatible
end
