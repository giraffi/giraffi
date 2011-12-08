module Giraffi
  class Client
    # Defines methods related to the applogs

    module Applogs
      # Returns the desired applogs related
      #
      # @requires_apikey Yes
      # @params options [Hash] The request params to retrieve the desired applogs
      # @return [HTTParty::Response]
      def find_applogs(options={})
        self.class.get("/applogs.json?apikey=#{apikey}", :query => options)
      end

      # Posts the applogs to the Giraffi
      #
      # @requires_apikey Yes
      # @params options [Hash] The applogs to post to the Giraffi
      # @return [HTTParty::Response]
      def add_applogs(options={})
        self.class.post("#{applogs_endpoint}/applogs.json?apikey=#{apikey}", :body => MultiJson.encode({applog: options}))
      end
    end
  end
end
