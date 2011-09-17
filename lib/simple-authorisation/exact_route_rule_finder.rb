require 'uri'

module Simple
  module Authorisation
    class ExactRouteRuleFinder < RouteRuleFinder
      def initialize(routes)
        super(routes)
        @find_by = [:route_by_wild_card, :route_matches]
        p @find_by
      end

      def route_matches(route_name)
        p "using route match"
        route_name = URI.parse(route_name).path.gsub(/\/$/, '')
        (@routes.keys.sort.reverse.select { |route| route =~ /#{route_name}\/?/ }).first
      end
    end
  end
end