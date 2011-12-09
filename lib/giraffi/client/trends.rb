module Giraffi
  class Client
    # Defines methods related to the trend data

    module Trends
      # Returns the desired trend data(average)
      #
      # @requires_apikey Yes
      # @param options [Hash] The request params to retrieve the desired trend data(average)
      # @return [HTTParty::Response]
      def find_average_trends(options={})
        self.class.get("/trends/average.json?apikey=#{apikey}", query: options)
      end

      # Returns the desired trend data(failure)
      #
      # @requires_apikey Yes
      # @param options [Hash] The request params to retrieve the desired trend data(failure)
      # @return [HTTParty::Response]
      def find_failure_trends(options={})
        self.class.get("/trends/failure.json?apikey=#{apikey}", query: options)
      end
    end
  end
end
