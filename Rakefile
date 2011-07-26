# encoding: utf-8
require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

$:.unshift(File.dirname(__FILE__) + '/lib')


desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  #t.rcov = ENV['RCOV']
  #t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
  t.verbose = true
end


task :default => [:spec]

require 'rake/clean'
CLEAN.include %w(**/*.{log,pyc,rbc,tgz} doc)