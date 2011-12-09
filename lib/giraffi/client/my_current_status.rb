module Giraffi
  class Client
  # Defines methods related to the status of endpoints

    module MyCurrentStatus
      # Returns the current status of the desired endpoint
      #
      # @requires_apikey No
      # @param options [String] The alias string of the desired endpoint
      # @return [HTTParty::Response]
      def my_current_status(options="")
        uri = to_uri options.to_sym
        raise StandardError.new("The given key `#{options}` is not valid.") if uri.nil?
        self.class.get("#{uri}/my_current_status.json")
      end

    end
  end
end
