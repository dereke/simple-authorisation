require 'sinatra/base'

module Sinatra
  module SinatraAuthorisation
    def self.registered(app)
      app.set :authorisation_login, '/login'
      app.set :authorisation_current_user, :current_user
      app.set :authorisation_anonymous_user_class, NilClass

      app.before do
        route_name = request.path
        user = send(options.authorisation_current_user)
        unless Simple::Authorisation.is_allowed?(route_name, :user => user, :anonymous_user_class => options.authorisation_anonymous_user_class, :method => request.request_method.downcase.to_sym)
          session[:return_to] = request.fullpath unless request.fullpath.include?('favicon.ico')
          redirect options.authorisation_login
          return false
        end
      end
    end

  end

  register SinatraAuthorisation
end