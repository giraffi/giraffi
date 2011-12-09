module Giraffi
  class Client
    # Defines methods related to the services

    module Services
      # Returns the desired services
      #
      # @requires_apikey Yes
      # @param options [Hash] The request params to retrieve the desired services
      # @return [HTTParty::Response]
      def find_services(options={})
        self.class.get("/services.json?apikey=#{apikey}", :query => options)
      end

      # Returns the desired service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the desired service
      # @return [HTTParty::Response]
      def find_service(id)
        self.class.get("/services/#{id}.json?apikey=#{apikey}")
      end

      # Returns the region related to the desired service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the desired service
      # @return [HTTParty::Response]
      def find_region_by_service(id)
        self.class.get("/services/#{id}/regions.json?apikey=#{apikey}") 
      end

      # Returns all triggers related to the desired service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the desired service
      # @return [HTTParty::Response]
      def find_triggers_by_service(id)
        self.class.get("/services/#{id}/triggers.json?apikey=#{apikey}")
      end

      # Adds a trigger to the service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the related service
      # @param options [Hash] A set of attributes for a trigger to add to the service
      # @return [HTTParty::Response]
      def add_trigger_to_service(id, options={})
        self.class.post("/services/#{id}/triggers.json?apikey=#{apikey}", :query => {:trigger => options})
      end

      # Updates the desired service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the desired service
      # @param options [Hash] A set of attributes to update the service
      # @return [HTTParty::Response]
      def update_service(id, options={})
        self.class.put("/services/#{id}.json?apikey=#{apikey}", :query => {:service => options}, :body => {})
      end

      # Updates the region related to the service
      #
      # @requires_apikey Yes
      # @param args [Array] A set of params to update the region
      # @option args [String] The numerical ID of the related service
      # @option args [String] The region code(e.g JP) to update
      # @return [HTTParty::Response]
      def update_region_of_service(*args)
        raise ArgumentError.new('The method `update_region_of_service` requires 2 arguments (service-id and region-code).') if args.size != 2
        self.class.put("/services/#{args[0]}/regions/#{args[-1]}.json?apikey=#{apikey}", :body => {})
      end

      # Deletes the service
      #
      # @requires_apikey Yes
      # @param id [String] The numerical ID of the desired service
      # @return [HTTParty::Response]
      def destroy_service(id)
        self.class.delete("/services/#{id}.json?apikey=#{apikey}")
      end

      # Removes a trigger from the service
      #
      # @requires_apikey Yes
      # @param args [Array] A set of params to remove a trigger from the service
      # @option args [String] The numerical ID of the related service
      # @option args [String] The numerical ID of the trigger to remove
      # @return [HTTParty::Response]
      def remove_trigger_from_service(*args)
        raise ArgumentError.new('The method `remove_trigger_from_service` requires 2 arguments (service-id and trigger-id).') if args.size != 2
        self.class.delete("/services/#{args[0]}/triggers/#{args[-1]}.json?apikey=#{apikey}")
      end
    end
  end
end

