# import all .rake files under lib/tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

if ENV['RACK_ENV'] == 'test'
  require 'cucumber'
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: [:set_rbenv_version, :features, :spec]
else
  task default: [:set_rbenv_version]
end

task :set_rbenv_version do
  ENV['RBENV_VERSION'] = '5b9e4f05846f6bd03b09b8572142f53fd7a46e62'
end

