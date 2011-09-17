require File.join(File.dirname(__FILE__), 'no_setting_for_route')
module Simple
  module Authorisation
    class RouteRuleFinder
      def initialize(routes)
        @routes = routes
      end

      def route_by_wild_card(route_name)
        (@routes.keys.sort.reverse.select{|route | route_name =~ /#{route.gsub('*', '.+')}/}).first
      end

      def route_starts_with(route_name)
        (@routes.keys.sort.reverse.select { |route| route_name.start_with?(route) }).first
      end

      def find(route_name)
        matching_route = route_by_wild_card(route_name)
        matching_route = route_starts_with(route_name) if matching_route.nil?

        route_settings = @routes[matching_route]
        raise NoSettingsForRoute.new(route_name) if route_settings.nil?


        route_settings
      end
    end
  end
end