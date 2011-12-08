module Giraffi
  class Client
  # Defines methods related to the status of endpoints

    module MyCurrentStatus
      # Returns the current status of the desired endpoint
      #
      # @requires_apikey No
      # @parm options [String] The alias string of the desired endpoint
      # @return [HTTParty::Response]
      def my_current_status(options="")
        uri = to_uri options.to_sym
        if uri.nil?
          MultiJson.encode({"my_current_status"=>{"domain"=>"I am not here", "alive"=>false}})
        else
          self.class.get("#{uri}/my_current_status.json")
        end
      end

      private
      # Returns the URL related to the given key
      #
      # @requires_apikey No
      # @parm options [String] The key for the real URI
      # @return URI
      def to_uri(key)
        {papi: endpoint,okapi: monitoringdata_endpoint,lapi: applogs_endpoint}[key]
      end
    end
  end
end
