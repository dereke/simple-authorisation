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
        user = send(options.authorisation_current_user)
        unless Simple::Authorisation.is_allowed?(
            route_name,
            :user => user,
            :anonymous_user_class => options.authorisation_anonymous_user_class,
            :method => request.request_method.downcase.to_sym)
          session[:return_to] = request.fullpath unless request.fullpath.include?('favicon.ico')

          if user.is_a? options.authorisation_anonymous_user_class
            redirect options.authorisation_login
          else
            redirect options.authorisation_permission_denied
          end
        end
      end

      app.get '/403' do
        "The action you have tried to perform is not available"
      end
    end

  end

  register SinatraAuthorisation
end