module Simple
  module Authorisation
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