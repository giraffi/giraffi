require 'test_helper'

class TrendsTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful" do
    setup do
      @service_id = 17972
    end

    context 'about the API related to the trend data' do
      should 'return the trend data about `average` related to the given service id' do
        stub_request(:get, "#{Giraffi.endpoint}/trends/average.json?apikey=#{apikey}").
          with(query: {service_id: @service_id.to_s},  headers: Giraffi.request_headers).
          to_return(body: fixture('find_average_trends.json'))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_average_trends({service_id: @service_id.to_s})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 4
      end

      should 'return the trend data about `failure` related to the given service id' do
        stub_request(:get, "#{Giraffi.endpoint}/trends/failure.json?apikey=#{apikey}").
          with(query: {service_id: @service_id.to_s},  headers: Giraffi.request_headers).
          to_return(body: fixture('find_failure_trends.json'))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_failure_trends({service_id: @service_id.to_s})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 2
        assert_equal JSON.parse(response.body)[0]['failed_time'], 4515
      end
    end

  end
end
