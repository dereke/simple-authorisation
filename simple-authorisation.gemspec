# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'simple-authorisation'
  s.version     = '0.0.4'
  s.authors     = ["Derek Ekins"]
  s.description = 'Handles authorisation only'
  s.summary     = "simple-authorisation-#{s.version}"
  s.email       = 'derek@spathi.com'
  s.homepage    = "http://github.com/dereke/simple-authorisation"

  s.platform    = Gem::Platform::RUBY
  s.post_install_message = %{
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)

Thank you for installing simple-authorisation

(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)

}

  s.add_dependency 'sinatra', '~> 1.2.6'

  s.add_development_dependency 'rake', '>= 0.9.2'
  s.add_development_dependency 'rspec', '>= 2.6.0'
  s.add_development_dependency 'sinatra', '>= 1.2.6'
  s.add_development_dependency 'rack-test', '>= 0.6.0'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_path     = "lib"
end