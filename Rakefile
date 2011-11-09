# encoding: utf-8
require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

$:.unshift(File.dirname(__FILE__) + '/lib')


task :coverage do
  require 'simplecov'
  require 'rspec/core'

  SimpleCov.start do
    add_filter 'spec'
  end
  SimpleCov.start
  RSpec::Core::Runner.run %w[spec]
end

task :default => [:coverage]

require 'rake/clean'
CLEAN.include %w(**/*.{log,pyc,rbc,tgz} doc)