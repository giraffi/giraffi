module Giraffi
  class Client
    # Defines methods related to the items

    module Items
      # Returns the desired items
      #
      # @requires_apikey Yes
      # @params options [Hash] The request params to retrieve the desired items
      # @return [HTTParty::Response]
      def find_items(options={})
        self.class.get("/items.json?apikey=#{apikey}", :query => options)
      end

      # Returns the desired item by the numerical ID
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired item
      # @return [HTTParty::Response]
      def find_item(id)
        self.class.get("/items/#{id}.json?apikey=#{apikey}")
      end

      # Returns the desired agent related to the item
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired item
      # @return [HTTParty::Response]
      def find_agent(id)
        # TODO
      end

      # Returns all services related to the item
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the item
      # @params options [Hash] A set of params to retrieve services related the item
      # @return [HTTParty::Response]
      def find_services_by_item(id, options={})
        self.class.get("/items/#{id}/services.json?apikey=#{apikey}", :query => options)
      end

      # Creates a new item
      #
      # @requires_apikey Yes
      # @params options [Hash] A set of attributes to create a new item
      # @return [HTTParty::Response]
      def create_item(options={})
        self.class.post("/items.json?apikey=#{apikey}", :query => { :item => options })
      end

      # Reloads all items
      #
      # @requires_apikey Yes
      # @return [HTTParty::Response]
      def reload_items
        self.class.post("/items/reload.json?apikey=#{apikey}")
      end

      # Adds a service to the item
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the related item
      # @params options [Hash] A set of attributes for a service to add to the item
      # @return [HTTParty::Response]
      def add_service_to_item(id, options={})
        self.class.post("/items/#{id}/services.json?apikey=#{apikey}", :query => { :service => options })
      end

      # Updates the desired item
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired item
      # @params options [Hash] A set of attributes to update the item
      # @return [HTTParty::Response]
      def update_item(id, options={})
        self.class.put("/items/#{id}.json?apikey=#{apikey}", :query => {:item => options}, :body => {})
      end

      # Deletes the item
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired item
      # @return [HTTParty::Response]
      def destroy_item(id)
        self.class.delete("/items/#{id}.json?apikey=#{apikey}")
      end

      # Removes a service from the item
      #
      # @requires_apikey Yes
      # @params args [Array] A set of params to remove a service from the item
      # @arg args [String] The numerical ID of the related item
      # @arg args [String] The numerical ID of the service to remove
      # @return [HTTParty::Response]
      def remove_service_from_item(*args)
        raise ArgumentError.new('The method `remove_service_from_item` requires 2 arguments (item-id and service-id)') if args.size != 2
        self.class.delete("/items/#{args[0]}/services/#{args[-1]}.json?apikey=#{apikey}")
      end
    end
  end
end
