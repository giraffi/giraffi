require 'test_helper'

class LogsTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @axion_id = '425'
    end

    context 'about the API related to the axion logs' do
      should 'return successfully the logs related to the axions with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/logs/axion.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_axion_logs_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axion_logs
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 4
        assert_equal JSON.parse(response.body)[0]['axion_id'], 422
      end

      should 'return successfully the logs related to the axions with params' do
        stub_request(:get, "#{Giraffi.endpoint}/logs/axion.json?apikey=#{apikey}").
          with(query: {axion_id: "425"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_axion_logs_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axion_logs({axion_id: @axion_id})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 3
        assert_equal JSON.parse(response.body)[0]['axion_id'], @axion_id.to_i
      end

      should 'return successfully the number of logs related to the axions with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/logs/axion/count.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: "4")

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.count_axion_logs

        assert response.ok?
        assert_equal response.body, "4"
      end

      should 'return successfully the number of logs related to the axions with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/logs/axion/count.json?apikey=#{apikey}").
          with(:query => {axion_id: @axion_id}, headers: Giraffi.request_headers).
          to_return(status: 200, body: "3")

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.count_axion_logs({axion_id: @axion_id})

        assert response.ok?
        assert_equal response.body, "3"
      end
    end

  end
end
