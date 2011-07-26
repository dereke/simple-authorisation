module Simple
  module Authorisation
    def self.route(name, options)
      @@routes ||= {}
      @@routes[name] = options
    end

    def self.is_allowed?(route_name, options)
      matching_route = (@@routes.keys.sort.reverse.select{|route | route_name.start_with?(route) }).first
      route_rules = @@routes[matching_route]
      raise "no rules found for #{route_name}" if route_rules.nil?
      allow = route_rules.fetch(:allow, [])
      deny = route_rules.fetch(:deny, [])
      user = options.fetch(:user, nil)
      anonymous_user_class = options.fetch(:anonymous_user_class, NilClass)

      return true if allow.index('?')
      return false if deny.index('?') and user.is_a? anonymous_user_class
      return true if allow.index('*') and not user.is_a? anonymous_user_class

      false
    end
  end
end