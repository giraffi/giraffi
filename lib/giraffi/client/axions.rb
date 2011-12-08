module Giraffi
  class Client
    # Defines methods related to the axions

    module Axions
      # Returns the desired axions
      #
      # @requires_apikey Yes
      # @params options [Hash] The request params to retrieve the desired axions
      # @return [HTTParty::Response]
      def find_axions(options={})
        self.class.get("/axions.json?apikey=#{apikey}", :query => options)
      end

      # Returns the desired axion
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired axion
      # @return [HTTParty::Response]
      def find_axion(id)
        self.class.get("/axions/#{id}.json?apikey=#{apikey}")
      end

      # Returns all media related to the desired axion
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired axion
      # @params options [Hash] A set of params to retrieve media related the axion
      # @return [HTTParty::Response]
      def find_media_by_axion(id, options={})
        self.class.get("/axions/#{id}/media.json?apikey=#{apikey}", :query => options)
      end

      # Creates a new axion
      #
      # @requires_apikey Yes
      # @params options [Hash] A set of attributes to create a new axion
      # @return [HTTParty::Response]
      def create_axion(options={})
        self.class.post("/axions.json?apikey=#{apikey}", :query => { :axion => options })
      end

      # Executes the desired axion
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired axion
      # @return [HTTParty::Response]
      def execute_axion(id)
        self.class.post("/axions/#{id}/execute.json?apikey=#{apikey}")
      end

      # Updates the desired axion
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired axion
      # @params options [Hash] A set of attributes to update the axion
      # @return [HTTParty::Response]
      def update_axion(id, options={})
        self.class.put("/axions/#{id}.json?apikey=#{apikey}", :query => { :axion => options }, :body => {})
      end

      # Adds a medium to the axion
      #
      # @requires_apikey Yes
      # @params args [Array] A set of params to add a medium to the axion
      # @arg args [String] The numerical ID of the related axion
      # @arg args [String] The numerical ID of the medium to add
      # @return [HTTParty::Response]
      def add_medium_to_axion(*args)
        raise ArgumentError.new('The method `add_medium_to_axion` requires 2 argments (axion-id and medium-id)') if args.size != 2
        self.class.put("/axions/#{args[0]}/media/#{args[-1]}.json?apikey=#{apikey}", :body => {})
      end

      # Deletes the axion
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired axion
      # @return [HTTParty::Response]
      def destroy_axion(id)
        self.class.delete("/axions/#{id}?apikey=#{apikey}")
      end

      # Removes a medium from the axion
      #
      # @requires_apikey Yes
      # @params args [Array] A set of params to remove a medium from the axion
      # @arg args [String] The numerical ID of the related axion
      # @arg args [String] The numerical ID of the axion to remove
      # @return [HTTParty::Response]
      def remove_medium_from_axion(*args)
        raise ArgumentError.new('The method `remove_medium_from_axion` requires 2 argments (axion-id and medium-id)') if args.size != 2
        self.class.delete("/axions/#{args[0]}/media/#{args[-1]}.json?apikey=#{apikey}")
      end
    end
  end
end
