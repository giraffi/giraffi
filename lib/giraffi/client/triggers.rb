module Giraffi
  class Client
    # Defines methods related to the triggers

    module Triggers
      # Returns the desired trigger
      #
      # @requires_apikey Yes
      # @params options [Hash] The request params to retrieve the desired triggers
      # @return [HTTParty::Response]
      def find_triggers(options={})
        self.class.get("/triggers.json?apikey=#{apikey}", :query => options)
      end

      # Returns the desired trigger
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired trigger
      # @return [HTTParty::Response]
      def find_trigger(id)
        self.class.get("/triggers/#{id}.json?apikey=#{apikey}")
      end

      # Returns all axions related to the desired trigger
      #
      # @requires_apikey Yes
      # @params args [Array] A set of params to retrieve axions related to the trigger
      # @arg args [String] The numerical ID of the related trigger
      # @arg args [String] The kind of axion [problem, recovery] to retrieve
      # @return [HTTParty::Response]
      def find_axions_by_trigger(*args)
        raise ArgumentError.new('The method `find_axions_by_trigger` requires at least a trigger id.') if args.size.zero?
        if args.size == 1
          self.class.get("/triggers/#{args[0]}/axions.json?apikey=#{apikey}")
        else
          self.class.get("/triggers/#{args[0]}/axions.json?apikey=#{apikey}", :query => {:axionkind => args[-1]})
        end
      end

      # Executes all axions related to the desired trigger
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired trigger
      # @return [HTTParty::Response]
      def execute_axions_by_trigger(id)
        self.class.post("/triggers/#{id}/axions/execute.json?apikey=#{apikey}")
      end

      # Updates the desired trigger
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired trigger
      # @params options [Hash] A set of attributes to update the trigger
      # @return [HTTParty::Response]
      def update_trigger(id, options={})
        self.class.put("/triggers/#{id}.json?apikey=#{apikey}", :query => {:trigger => options}, :body => {})
      end

      # Updates the axion related to the desired trigger
      #
      # @requires_apikey Yes
      # @params args [Array] A set of parmas to update the axion related to the trigger
      # @arg args [String] The numerical ID of the related trigger
      # @arg args [String] The numerical ID of the desired axion
      # @arg args [String] The kind of axion [problem, recovery] to update
      # @return [HTTParty::Response]
      def update_axion_by_trigger(*args)
        raise ArgumentError.new('The method `update_axion_by_trigger` requires 3 argments (trigger-id, axion-id and axion-kind)') if args.size != 3
        self.class.put("/triggers/#{args[0]}/axions/#{args[1]}.json?apikey=#{apikey}", :query => { :axionkind => args[-1] }, :body => {})
      end

      # Deletes the trigger
      #
      # @requires_apikey Yes
      # @params id [String] The numerical ID of the desired trigger
      # @return [HTTParty::Response]
      def destroy_trigger(id)
        self.class.delete("/triggers/#{id}.json?apikey=#{apikey}")
      end

      # Removes an axion from the trigger
      #
      # @requires_apikey Yes
      # @params args [Array] A set of parmas to remove an axion from the trigger
      # @arg args [String] The numerical ID of the related trigger
      # @arg args [String] The numerical ID of the axion to remove
      # @return [HTTParty::Response]
      def remove_axion_from_trigger(*args)
        raise ArgumentError.new('The method `remove_axion_from_trigger` requires 2 arguments (trigger-id and axion-id)') if args.size != 2
        self.class.delete("/triggers/#{args[0]}/axions/#{args[-1]}.json?apikey=#{apikey}")
      end
    end
  end
end
