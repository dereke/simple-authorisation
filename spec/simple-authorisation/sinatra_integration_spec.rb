require 'spec_helper'
require "rack/test"
require 'simple-authorisation/sinatra'


module Sinatra
  describe "Authorisation" do
    before do
      @session = Rack::Test::Session.new(TestApp)
    end

    it "asks Simple::Authorisation if access is allowed" do
      Simple::Authorisation.route '/', :allow => ['?']
      @session.get '/'

      # this fails for some reason but I know that it does work - what is wrong???
      Simple::Authorisation.should_receive(:is_allowed?).with("/", {:user=>nil})
    end

  end

  class TestApp < Sinatra::Application
    set :environment, :test


    get "/" do
      "Nothing to see here"
    end

    def current_user
      nil
    end
  end
end