module Simple
  module Authorisation
    def self.post(name, options)
      options[:method] = :post
      self.route(name, options)
    end

    def self.get(name, options)
      options[:method] = :get
      self.route(name, options)
    end

    def self.route(name, options)
      @@routes ||= {}
      @@routes[name] = {} unless @@routes.has_key?(name)

      route_settings  = @@routes[name]
      route_settings[options.delete(:method) || :any] = options
    end

    def self.clear
      @@routes = {}
    end

    def self.is_allowed?(route_name, options)
      matching_route = (@@routes.keys.sort.reverse.select{|route | route_name.start_with?(route) }).first

      route_settings = @@routes[matching_route]
      raise NoSettingsForRoute.new(route_name) if route_settings.nil?

      method = options.fetch(:method, :any)
      route_rules = route_settings[method] || route_settings[:any]
      raise NoRulesForMethod.new(route_name, method) if route_rules.nil?

      allow = route_rules.fetch(:allow, [])
      deny = route_rules.fetch(:deny, [])
      user = options.fetch(:user, nil)


      anonymous_user_class = options.fetch(:anonymous_user_class, NilClass)

      return true   if allow.index('?')
      return false  if deny.index('?')  and     user.is_a? anonymous_user_class
      return true   if allow.index('*') and not user.is_a? anonymous_user_class
      allow.each do | allowed |
        return true if user.actions.include?(allowed)
      end if user.respond_to? :actions

      false
    end

    class NoRulesForMethod < Exception
      def initialize(route_name, method)
        @route_name = route_name
        @method = method
      end

      def message
        "no rules found for #{@route_name} method #{@method}"
      end
    end

    class NoSettingsForRoute < Exception
      def initialize(route_name)
        @route_name = route_name
      end

      def message
        "No settings for route #{@route_name}"
      end
    end
  end
end