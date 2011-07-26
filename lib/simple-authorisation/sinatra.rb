require 'sinatra/base'

module Sinatra
  module SinatraAuthorisation
    def self.registered(app)
      app.set :authorisation_login, '/login'
      app.set :authorisation_current_user, :current_user
      app.set :authorisation_anonymous_user_class, NilClass

      app.before do
        route_name = request.path
        unless Simple::Authorisation.is_allowed?(route_name, :user => current_user, :anonymous_user_class => options.authorisation_anonymous_user_class)
          session[:return_to] = request.fullpath unless request.fullpath.include?('favicon.ico')
          redirect options.authorisation_login
          return false
        end
      end
    end

  end

  register SinatraAuthorisation
end