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
        if URIs[options.to_sym]
          self.class.get("#{URIs[options.to_sym]}/my_current_status.json")
        else
          {"my_current_status"=>{"domain"=>"I am not here", "alive"=>false}}
        end
      end
    end
  end
end
