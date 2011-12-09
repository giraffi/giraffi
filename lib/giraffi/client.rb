require 'httparty'
require 'multi_json'
require 'giraffi/config'

module Giraffi
  # Warpper for the Giraffi RESTful API

  class Client
    include MultiJson
    include HTTParty
    base_uri Config::DEFAULT_ENDPOINT
    headers Config::DEFAULT_REQUEST_HEADERS
    format :plain #:json
    #debug_output

    # Requires client method modules
    require 'giraffi/client/items'
    require 'giraffi/client/services'
    require 'giraffi/client/media'
    require 'giraffi/client/axions'
    require 'giraffi/client/applogs'
    require 'giraffi/client/logs'
    require 'giraffi/client/monitoringdata'
    require 'giraffi/client/my_current_status'
    require 'giraffi/client/regions'
    require 'giraffi/client/trends'
    require 'giraffi/client/triggers'

    include Giraffi::Client::Items
    include Giraffi::Client::Services
    include Giraffi::Client::Media
    include Giraffi::Client::Axions
    include Giraffi::Client::Applogs
    include Giraffi::Client::Logs
    include Giraffi::Client::Monitoringdata
    include Giraffi::Client::MyCurrentStatus
    include Giraffi::Client::Regions
    include Giraffi::Client::Trends
    include Giraffi::Client::Triggers

    # @return [Array] the attributes +Config::VALID_OPTIONS_KEYS+ as a Array
    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Examines a bad response and raise an appropriate error
    #
    # @param response [HTTParty::Response]
    def bad_response(response)
      if response.class == HTTParty::Response
        raise ResponseError, response
      end
      raise StandardError, "Unknown error"
    end

    # Initializes a new API object
    #
    # @param attrs [Hash] The options allows you to access the Giraffi RESTful API
    # @return [Giraffi::Client]
    def initialize(attrs={})
      attrs = Giraffi.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    # Returns the URL related to the given key
    #
    # @param options [Symbol] The keyword related to the real URI
    # @return [String] URI or nil when no matching value
    def to_uri(key)
      {papi: endpoint,okapi: monitoringdata_endpoint,lapi: applogs_endpoint}[key] || nil
    end
  end
end
