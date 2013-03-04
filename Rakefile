require "rubygems"
require "bundler"
Bundler.setup
require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :spec

require "cucumber/rake/task"
Cucumber::Rake::Task.new(:features)
task :features

task :default => [:spec, :features]

# Don't print commands when shelling  out (for example, running Cucumber)
RakeFileUtils.verbose(false)
