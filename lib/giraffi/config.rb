require 'giraffi/version'

module Giraffi
  module Config

    DEFAULT_REQUEST_HEADERS = {
      "User-Agent"    => "Giraffi Ruby Gem #{Giraffi::Version}",
      "Accept"        => "application/json",
      "Content-Type"  => "application/json"
    }

    DEFAULT_ENDPOINT                = 'https://papi.giraffi.jp'
    DEFAULT_MONITORINGDATA_ENDPOINT = 'https://okapi.giraffi.jp:3007'
    DEFAULT_APPLOGS_ENDPOINT        = 'https://lapi.giraffi.jp:3443'
    DEFAULT_APIKEY                  = nil

    VALID_OPTIONS_KEYS = [
      :request_headers,
      :endpoint,
      :monitoringdata_endpoint,
      :applogs_endpoint,
      :apikey
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    def reset
      self.request_headers          = DEFAULT_REQUEST_HEADERS
      self.endpoint                 = DEFAULT_ENDPOINT
      self.monitoringdata_endpoint  = DEFAULT_MONITORINGDATA_ENDPOINT
      self.applogs_endpoint         = DEFAULT_APPLOGS_ENDPOINT
      self.apikey                   = DEFAULT_APIKEY
    end

  end
end
