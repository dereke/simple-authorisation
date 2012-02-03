require 'cgi'
require 'sinatra/base'

module Sinatra
  module SinatraAuthorisation
    def self.registered(app)
      app.set :authorisation_login, '/login'
      app.set :authorisation_permission_denied, '/403'
      app.set :authorisation_current_user, :current_user
      app.set :authorisation_anonymous_user_class, NilClass

      app.before do
        route_name = request.path
        request_user = Proc.new { send(settings.authorisation_current_user) }

        unless Simple::Authorisation.is_allowed?(
            route_name,
            :user => request_user,
            :anonymous_user_class => settings.authorisation_anonymous_user_class,
            :method => request.request_method.downcase.to_sym)
          session[:return_to] = request.fullpath unless request.fullpath.include?('favicon.ico')

          user = request_user.call

          if user.is_a? settings.authorisation_anonymous_user_class
            redirect settings.authorisation_login + "?requested_url=#{CGI.escape(request.fullpath)}"
          else
            redirect settings.authorisation_permission_denied
          end
        end
      end

      app.get '/403' do
        haml 'The action you have tried to perform is not available'
      end
    end

  end

  register SinatraAuthorisation
end
