require 'builder'

module Simple
  module AuthorisationHelper
    def link (route, link_options)
      user = send(options.authorisation_current_user)
      link = Builder::XmlMarkup.new

      if Simple::Authorisation.is_allowed?(route, :user => user,
              :anonymous_user_class => options.authorisation_anonymous_user_class,
              :method => :get)
        main_link = lambda { link.a(:href => route) { |a| a << link_options[:text] }}
        if link_options[:nest]
          link.li {main_link.call}
        else
          main_link.call
        end
      end
      link.target!
    end
  end
end