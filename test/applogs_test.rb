require 'test_helper'
require 'json'

class ApplogsTest < Test::Unit::TestCase

  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @applog_attrs = {
        :level => "error",
        :type => "app",
        :time => "1323318027.9443982",
        :message => "Internal Server Error 500"
      }
    end

    context 'about the API related to the applogs' do
      should 'return successfully all applogs without no param' do
        stub_request(:get, "#{Giraffi.endpoint}/applogs.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_applogs_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_applogs
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 8
        assert_equal JSON.parse(response.body)[0]['applog']['time'], 1317782732.9443982
      end

      should 'return successfully the applogs with params' do
        stub_request(:get, "#{Giraffi.endpoint}/applogs.json?apikey=#{apikey}").
          with(query: {level: "error"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_applogs_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_applogs({level: "error"})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['applog']['level'], 'error'
      end

      should 'add successfully the applogs to the Giraffi' do
        stub_request(:post, "#{Giraffi.applogs_endpoint}/applogs.json?apikey=#{apikey}").
          with(body: MultiJson.encode({applog: @applog_attrs}), headers: Giraffi.request_headers).
          to_return(status: 200, body: fixture("add_applogs_success_response.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.add_applogs(@applog_attrs)
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)['status'], 'Success to logging'
      end
    end

  end
end
