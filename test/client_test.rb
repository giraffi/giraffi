require 'test_helper'

class ClientTest < Test::Unit::TestCase
  context 'Testing the Ruby Gem for the Giraffi RESTful API' do
    setup do
      @keys = Giraffi::Config::VALID_OPTIONS_KEYS
      @configuration = {
        :request_headers => {
          "User-Agent" => "OreOre Ruby Gem",
          "Accept" => "application/json",
          "Content-Type"  => "application/json"
        },
        :timeout  => 10,
        :endpoint => "http://tumblr.com/",
        :monitoringdata_endpoint => "http://google.com/",
        :applogs_endpoint => "http://twitter.com",
        :apikey => "test-key"
      }
    end

    context 'about the class `client`' do
      should 'override module configuration' do
        giraffi = Giraffi.new(@configuration)
        @keys.each do |key|
          assert_equal giraffi.send(key), @configuration[key]
        end
      end

      should 'override module configuration after initialization' do
        giraffi = Giraffi.new
        @configuration.each do |key, value|
          giraffi.send("#{key}=", value)
        end
        @keys.each do |key|
          assert_equal giraffi.send(key), @configuration[key]
        end
      end

      should 'return the URI with the valid symbol given to `to_uri`' do
        giraffi = Giraffi.new
        uri = giraffi.to_uri(:papi)
        assert_not_nil uri
        assert_equal uri, 'https://papi.giraffi.jp'
      end

      should 'return nil with the invalid symbol given to `to_uri`' do
        giraffi = Giraffi.new
        uri = giraffi.to_uri(:foo)
        assert_nil uri
      end
    end
  end
end
