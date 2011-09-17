require File.join(File.dirname(__FILE__), 'no_setting_for_route')
module Simple
  module Authorisation
    class RouteRuleFinder
      def initialize(routes)
        @routes = routes
        @find_by = [:route_by_wild_card, :route_starts_with]
      end

      def route_by_wild_card(route_name)
        (@routes.keys.sort.reverse.select{|route | route_name =~ /^#{route.gsub('*', '.+')}$/}).first
      end

      def route_starts_with(route_name)
        (@routes.keys.sort.reverse.select { |route| route_name.start_with?(route) }).first
      end

      def find(route_name)
        matching_route = nil
        @find_by.each do |method|
          matching_route = send(method, route_name)
          break unless matching_route.nil?
        end

        route_settings = @routes[matching_route]
        raise NoSettingsForRoute.new(route_name) if route_settings.nil?

        route_settings
      end
    end
  end
end