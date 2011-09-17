require File.join(File.dirname(__FILE__), 'route_rule_finder')
require File.join(File.dirname(__FILE__), 'exact_route_rule_finder')
require File.join(File.dirname(__FILE__), 'no_rules_for_method')

module Simple
  module Authorisation
    @@match_style = :default

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
      match_styles = {
          :default  => RouteRuleFinder,
          :exact    => ExactRouteRuleFinder
      }
      route_matcher = match_styles[match_style].new(@@routes)
      route_settings = route_matcher.find(route_name)

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

    def self.match_style=(style)
      @@match_style = style
    end

    def self.match_style
      @@match_style
    end
  end
end