module Giraffi
  class Client
    # Defines methods related to the logs generated by the Giraffi

    module Logs
      # Returns the desired logs related to the axions
      #
      # @param options [Hash] The request params to retrieve the desired logs
      # @return [HTTParty::Response]
      def find_axion_logs(options={})
        self.class.get("/logs/axion.json?apikey=#{apikey}", query: options)
      end

      # Returns the number of logs related to the axions
      #
      # @param options [Hash] The request params to retrieve the desired logs to count
      # @return [HTTParty::Response]
      def count_axion_logs(options={})
        self.class.get("/logs/axion/count.json?apikey=#{apikey}", query: options)
      end
    end
  end
end
