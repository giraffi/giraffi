require 'test_helper'
require 'json'

class MyCurrentStatusTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful" do

    context 'about the API related to the current status of the Giraffi API' do
      should 'return the status related to the requested URI' do
        stub_request(:get, "#{Giraffi.endpoint}/my_current_status.json").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("my_current_status_about_real_uri.json"))

        giraffi = Giraffi.new
        response = giraffi.my_current_status('papi')
        assert response.ok?
        assert_equal JSON.parse(response.body)['my_current_status']['domain'], Giraffi.endpoint.sub(/https:\/\//,'')
        assert JSON.parse(response.body)['my_current_status']['alive']
      end

      should 'raise an error when the invalid keyword is given to `my_current_status`' do
        giraffi = Giraffi.new
        assert_raise StandardError do
          giraffi.my_current_status('foo')
        end
      end
    end

  end
end
