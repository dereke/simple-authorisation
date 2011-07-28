require 'simple-authorisation/authorisation'

module Simple
  describe Authorisation do
    before do
      Simple::Authorisation.clear
    end
    it "should allow requests to anonymous users" do
      Simple::Authorisation.route '/test', :allow => ['?']
      Simple::Authorisation.is_allowed?('/test', :user => nil).should be_true
    end

    it "should deny request to anonymous users" do
      Simple::Authorisation.route '/test', :deny => ['?']
      Simple::Authorisation.is_allowed?('/test', :user => nil).should be_false
    end

    it "should allow requests to any user" do
      Simple::Authorisation.route '/test', :allow => ['*']
      Simple::Authorisation.is_allowed?('/test', :user => Object.new).should be_true
    end

    it "should allow requests to any user but deny requests to anonymous users" do
      Simple::Authorisation.route '/test', :allow => ['*'], :deny => ['?']
      Simple::Authorisation.is_allowed?('/test', :user => Object.new).should be_true
      Simple::Authorisation.is_allowed?('/test', :user => nil).should be_false
    end

    it "should find rules for a hierarchy" do
      Simple::Authorisation.route '/test', :allow => ['?']
      Simple::Authorisation.is_allowed?('/test/page', :user => nil).should be_true
    end

    it "should find rules for a hierarchy and apply most appropriate rule" do
      Simple::Authorisation.route '/test/page', :allow => ['?']
      Simple::Authorisation.route '/test', :deny=> ['?']
      Simple::Authorisation.is_allowed?('/test/page/low', :user => nil).should be_true
    end

    it "should apply rules just to a particular method" do
      Simple::Authorisation.post '/test', :deny => ['?']
      Simple::Authorisation.get '/test', :allow => ['?']

      Simple::Authorisation.is_allowed?('/test', :method => :post, :user => nil).should be_false
      Simple::Authorisation.is_allowed?('/test', :method => :get, :user => nil).should be_true
    end

    it "should apply rule to any method when none specified" do
      Simple::Authorisation.route '/test', :allow => ['?']
      Simple::Authorisation.is_allowed?('/test', :method => :get, :user => nil).should be_true
      Simple::Authorisation.is_allowed?('/test', :method => :post, :user => nil).should be_true
    end

    it "should raise an exception when checking is_allowed for a route with no rules" do
      lambda {Simple::Authorisation.is_allowed?('/test', :method => :get, :user => nil)}.should raise_error(Simple::Authorisation::NoSettingsForRoute)
    end
  end
end