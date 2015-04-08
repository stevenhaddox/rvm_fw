source 'http://rubygems.org'
gem 'haml', '~> 3.1.8' # < 4.0 for Ruby 1.8.7
gem 'json', '~>1.8.0'
gem 'rake', '~> 10.0'
gem 'sinatra', :require => 'sinatra/base'
gem 'rack'
gem 'thin' # Puma isn't happy with 1.8.7 easily

# Important compatibility versions
gem 'tilt', '~> 1.4.1'
gem 'mime-types', '~> 1.25.1'
gem 'nokogiri', '~> 1.5.11'

group :development do
  gem 'bootstrap-sass', '~> 2.3.2.2'
  gem 'compass', '~> 0.12'
  gem 'foreman'
  gem 'travis-lint'
end

group :test do
  gem 'capybara', '~> 2.0.3' # Ruby < 1.9.3 compatible
  gem 'rubyzip', '~> 0.9.9' # Ruby < 1.9.3 compatible
  gem 'cucumber-sinatra'
  gem 'cucumber'
  gem 'rspec'
end
