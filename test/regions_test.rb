require 'test_helper'

class RegionsTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do

    context 'about the API related to the regions' do
      should 'return all the valid regions' do
        stub_request(:get, "#{Giraffi.endpoint}/regions.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture('find_regions.json'))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_regions
        assert response.ok?
        assert_equal JSON.parse(response.body)[0]['region']['code'], "JP"
      end
    end

  end
end
