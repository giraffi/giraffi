module Giraffi
  class Client
    # Defines methods related to the monitoring data

    module Monitoringdata
      # Returns the desired monitoring data
      #
      # @requires_apikey Yes
      # @params options [Hash] The request params to retrieve the desired monitoring data
      # @return [HTTParty::Response]
      def find_monitoringdata(options={})
        self.class.get("/monitoringdata.json?apikey=#{apikey}", query: options)
      end

      # Posts the monitoring data to the Giraffi
      #
      # @requires_apikey Yes
      # @params options [Hash] The monitoring data to post to the Giraffi
      # @return [HTTParty::Response]
      def add_monitoringdata(options={})
        self.class.post("#{monitoringdata_endpoint}/internal/nodelayed?apikey=#{apikey}", :body => MultiJson.encode({:internal => options}))
      end
    end
  end
end
