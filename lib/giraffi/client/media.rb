module Giraffi
  class Client
    # Defines methods related to the media

    module Media
      # Returns the desired media
      #
      # @param options [Hash] The request params to retrieve the desired media
      # @return [HTTParty::Response]
      def find_media(options={})
        self.class.get("/media.json?apikey=#{apikey}", :query => options)
      end

      # Returns the desired medium
      #
      # @param id [String] The numerical ID of the desired medium
      # @return [HTTParty::Response]
      def find_medium(id)
        self.class.get("/media/#{id}.json?apikey=#{apikey}")
      end

      # Returns the desired oauth
      #
      # @param id [String] The numerical ID of the desired medium
      # @return [HTTParty::Response]
      def find_oauth_by_medium(id)
        self.class.get("/media/#{id}/oauth.json?apikey=#{apikey}")
      end

      # Returns the oauth-callbacks related to the medium
      #
      # @param args [Array] A set of params to retrieve the desired oauth-callback
      # @option args [String] The numerical ID of the desired medium
      # @option args [String] The oauth verifier related to the callback
      # @return [HTTParty::Response]
      def find_oauth_callback_by_medium(*args)
        raise ArgumentError.new('The method `find_oauth_callback_by_medium` requires 2 arguments(medium-id and oauth-token)') if args.size != 2
        self.class.get("/media/#{args[0]}/oauth_callback.json?apikey=#{apikey}", :query => {:oauth_verifier => args[-1]})
      end

      # Creates a new medium
      #
      # @param options [Hash] A set of attributes to create a new medium
      # @return [HTTParty::Response]
      def create_medium(options={})
        self.class.post("/media.json?apikey=#{apikey}", :query => { :medium => options })
      end

      # Updates the desired medium
      #
      # @param id [String] The numerical ID of the desired medium
      # @param options [Hash] A set of attributes to update the medium
      # @return [HTTParty::Response]
      def update_medium(id, options={})
        self.class.put("/media/#{id}.json?apikey=#{apikey}", :query => {:medium => options}, :body => {})
      end

      # Deletes the medium
      #
      # @param id [String] The numerical ID of the desired medium
      # @return [HTTParty::Response]
      def destroy_medium(id)
        self.class.delete("/media/#{id}?apikey=#{apikey}")
      end
    end
  end
end
