require 'simple-authorisation/authorisation'
require 'simple-authorisation/authorisation_helper'

module Simple
  describe AuthorisationHelper do
    before do
      Simple::Authorisation.clear
      @helper = Object.new
      @helper.extend Simple::AuthorisationHelper

      def @helper.options
        options = Object.new
        def options.authorisation_anonymous_user_class
          NilClass
        end

        def options.authorisation_current_user
          :current_user
        end
        options
      end
    end

    it 'returns a link if you have permission to view it' do
      def @helper.current_user
        Object.new
      end

      Simple::Authorisation.get '/', :allow => ['*']

      @helper.link('/', :text => 'Home').should == '<a href="/">Home</a>'
    end


    it 'returns a nested link if you have permission to view it' do
      def @helper.current_user
        Object.new
      end

      Simple::Authorisation.get '/', :allow => ['*']

      @helper.link('/', :text => 'Home', :nest => true).should == '<li><a href="/">Home</a></li>'
    end

    it "does not return a link if you do not have permission to view it" do
      def @helper.current_user
        nil
      end

      Simple::Authorisation.get '/', :deny => ['?']

      @helper.link('/', :text => 'Home').should == ''
    end
  end
end
