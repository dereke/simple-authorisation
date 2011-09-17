module Simple
  module Authorisation
    class NoRulesForMethod < Exception
      def initialize(route_name, method)
        @route_name = route_name
        @method = method
      end

      def message
        "no rules found for #{@route_name} method #{@method}"
      end
    end
  end
end