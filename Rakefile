# import all .rake files under lib/tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :features]
