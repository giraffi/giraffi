require 'test_helper'

class ServicesTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @item_id = 3681
      @service_id = 17972
      @region_code = 'JP'
      @trigger_id = '123'

      @trigger_attrs = {
        triggertype: "timeout",
        axioninterval: "180",
        options: {
          time: "3"
        }
      }

      @service_attrs = {
        status: "0"
      }
    end

    context 'about the API related to the services' do
      should 'return successfully the desired services with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/services.json?apikey=#{apikey}").
          with(:query => {}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_services_with_no_param.json"), headers: Giraffi.request_headers)

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_services({})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 3
      end

      should 'return successfully the desired service with params' do
        stub_request(:get, "#{Giraffi.endpoint}/services.json?apikey=#{apikey}").
          with(:query => {:item_id => @item_id.to_s}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_services_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_services({item_id: "#{@item_id}"})
        assert response.ok?
        assert_equal JSON.parse(response.body)[0]['service']['item_id'], @item_id
      end

      should 'return successfully the desired service by the numerical ID' do
        stub_request(:get, "#{Giraffi.endpoint}/services/#{@service_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_service_by_id.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_service(@service_id)
        assert response.ok?
        assert_equal JSON.parse(response.body)['service']['id'], @service_id
      end

      should 'return successfully the region related to the service' do
        stub_request(:get, "#{Giraffi.endpoint}/services/#{@service_id}/regions.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_region_by_service.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_region_by_service(@service_id)
        assert response.ok?
        assert_equal @region_code, JSON.parse(response.body)[0]['region']['code']
      end

      should 'return successfully the triggers related to the service' do
        stub_request(:get, "#{Giraffi.endpoint}/services/#{@service_id}/triggers.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_triggers_by_service.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_triggers_by_service(@service_id)
        assert response.ok?
        assert_equal JSON.parse(response.body)[0]['trigger']['triggertype'], 'timeout'
      end

      should 'add successfully a trigger to the desired service' do
        stub_request(:post, "#{Giraffi.endpoint}/services/#{@service_id}/triggers.json?apikey=#{apikey}").
          with(:query => {:trigger => @trigger_attrs}, headers: Giraffi.request_headers).
          to_return(body: fixture("add_trigger_to_service.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.add_trigger_to_service(@service_id, @trigger_attrs)
        assert response.ok?
        assert_equal JSON.parse(response.body)['trigger']['triggertype'], 'timeout'
      end

      should 'update successfully the desired service' do
        stub_request(:put, "#{Giraffi.endpoint}/services/#{@service_id}.json?apikey=#{apikey}").
          with(:body => {}, :query => {:service => @service_attrs}, headers: Giraffi.request_headers).
          to_return(body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_service(@service_id, @service_attrs)
        assert response.ok?
        assert response.body == {}
      end

      should 'update successfully the region related to the service' do
        stub_request(:put, "#{Giraffi.endpoint}/services/#{@service_id}/regions/JP.json?apikey=#{apikey}").
          with(:body => {}, headers: Giraffi.request_headers).
          to_return(body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_region_of_service(@service_id, 'JP')
        assert_nothing_raised ArgumentError do
          giraffi.update_region_of_service(@service_id, 'JP')
        end
        assert response.ok?
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `update_region_of_service` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.update_region_of_service(@service_id)
        end
      end

      should 'not update the region related to the service with unknown regions code' do
        stub_request(:put, "#{Giraffi.endpoint}/services/#{@service_id}/regions/US.json?apikey=#{apikey}").
          with(:body => {}, headers: Giraffi.request_headers).
          to_return(body: '{"error":"This id is not found."}')

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_region_of_service(@service_id, 'US')
        assert response.ok?
        assert_equal JSON.parse(response.body)['error'], "This id is not found."
      end

      should 'delete successfully the service' do
        stub_request(:delete, "#{Giraffi.endpoint}/services/#{@service_id}.json?apikey=#{apikey}").
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.destroy_service(@service_id)
        assert response.ok?
        assert response.body == {}
      end

      should 'remove successfully a trigger from the service' do
        stub_request(:delete, "#{Giraffi.endpoint}/services/#{@service_id}/triggers/#{@trigger_id}.json?apikey=#{apikey}").
          to_return(:body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.remove_trigger_from_service(@service_id, @trigger_id)
        assert_nothing_raised ArgumentError do
          giraffi.remove_trigger_from_service(@service_id, @trigger_id)
        end
        assert response.ok?
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `remove_trigger_from_service` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.remove_trigger_from_service(@service_id)
        end
      end
    end

  end
end
