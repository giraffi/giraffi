require 'giraffi/version'

module Giraffi
  # Defines constants and methods related to configuration
  module Config

    # The HTTP request header if none is set
    DEFAULT_REQUEST_HEADERS = {
      "User-Agent"    => "Giraffi Ruby Gem #{Giraffi::Version}",
      "Accept"        => "application/json",
      "Content-Type"  => "application/json"
    }

    # The timeout for all HTTP calls if none is set in seconds
    DEFAULT_TIMEOUT                 = 10

    # The basic endpoint if none is set
    DEFAULT_ENDPOINT                = 'https://papi.giraffi.jp'

    # The endpoint for posting the monitoringdata if none is set
    DEFAULT_MONITORINGDATA_ENDPOINT = 'https://okapi.giraffi.jp:3007'

    # The endpoint for posting the application logs if none is set
    DEFAULT_APPLOGS_ENDPOINT        = 'https://lapi.giraffi.jp:3443'

    # The APIKEY to allow you to use the Giraffi API if none is set
    DEFAULT_APIKEY                  = nil

    # An array of valid keys in the options hash when configuring a {Giraffi::Client}
    VALID_OPTIONS_KEYS = [
      :request_headers,
      :timeout,
      :endpoint,
      :monitoringdata_endpoint,
      :applogs_endpoint,
      :apikey
    ]

    # @return [Array] the attribute +VALID_OPTIONS_KEYS+ as an Array
    attr_accessor *VALID_OPTIONS_KEYS

    # Set all configuration options to thier values when this module is extended
    def self.extended(base)
      base.reset
    end

    # Create a hash of options and thier values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.request_headers          = DEFAULT_REQUEST_HEADERS
      self.timeout                  = DEFAULT_TIMEOUT
      self.endpoint                 = DEFAULT_ENDPOINT
      self.monitoringdata_endpoint  = DEFAULT_MONITORINGDATA_ENDPOINT
      self.applogs_endpoint         = DEFAULT_APPLOGS_ENDPOINT
      self.apikey                   = DEFAULT_APIKEY
    end

  end
end
