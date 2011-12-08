$:.unshift File.dirname(__FILE__)
require 'giraffi/client'
require 'giraffi/config'

module Giraffi
  extend Config
  class << self
    # Alias for Giraffi::Client.new
    #
    # @params options [Hash] The APIKEY allows you to access the Giraffi RESTful API
    # @return [Giraffi::Client]
    def new(options={})
      Giraffi::Client.new(options)
    end

    # Delegate to Giraffi::Client
    def method_missing(method, *args, &blocks)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
