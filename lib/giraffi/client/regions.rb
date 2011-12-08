module Giraffi
  class Client
    # Defines methods related to the regions

    module Regions
      # Returns all available regions
      #
      # @requires_apikey Yes
      # @return [HTTParty::Response]
      def find_regions
        self.class.get("/regions.json?apikey=#{apikey}")
      end
    end
  end
end
