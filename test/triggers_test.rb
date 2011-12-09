require 'test_helper'

class TriggersGiraffi < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful" do
    setup do
      @axion_id = '425'
      @trigger_id = '123'
    end

    context 'about the API related to the triggers' do
      should 'return successfully the desired triggers with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/triggers.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_triggers_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_triggers
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 3
        assert_equal JSON.parse(response.body)[0]['trigger']['triggertype'], "timeout"
      end

      should 'return successfully the desired triggers with params' do
        stub_request(:get, "#{Giraffi.endpoint}/triggers.json?apikey=#{apikey}").
          with(query: {triggertype: "traffic"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_triggers_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_triggers({triggertype: "traffic"})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['trigger']['triggertype'], "traffic"
      end

      should 'return successfully the desired trigger by the numerical ID' do
        stub_request(:get, "#{Giraffi.endpoint}/triggers/#{@trigger_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_trigger_by_id.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_trigger(@trigger_id)
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)['trigger']['id'], @trigger_id.to_i
      end

      should 'return successfully the axions related to the trigger without the `axionkind` param' do
        stub_request(:get, "#{Giraffi.endpoint}/triggers/#{@trigger_id}/axions.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_axions_by_trigger_without_axionkind.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axions_by_trigger(@trigger_id)
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['axion']['id'], @axion_id.to_i
      end

      should 'return successfully the axions related to the trigger with the `axionkind` param' do
        stub_request(:get, "#{Giraffi.endpoint}/triggers/#{@trigger_id}/axions.json?apikey=#{apikey}").
          with(:query => {axionkind: "problem"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_axions_by_trigger_with_axionkind.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axions_by_trigger(@trigger_id, "problem")
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['axion']['id'], @axion_id.to_i
      end

      should 'raise an error when no argument is given to `find_axions_by_trigger`' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.find_axions_by_trigger
        end
      end

      should 'execute successfully all the axions related to the triggers' do
        stub_request(:post, "#{Giraffi.endpoint}/triggers/#{@trigger_id}/axions/execute.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: "[#{@axion_id}]\n")

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.execute_axions_by_trigger(@trigger_id)
        assert response.ok?
        assert_equal response.body, "[#{@axion_id}]\n"
      end

      should 'update successfully the desired trigger' do
        stub_request(:put, "#{Giraffi.endpoint}/triggers/#{@trigger_id}.json?apikey=#{apikey}").
          with(body: {}, query: {trigger: {options: {time: "10"}}}, headers: Giraffi.request_headers).
          to_return(status: 200, body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_trigger(@trigger_id, {options: {time: "10"}})
        assert response.ok?
        assert response.body == {}
      end

      should 'update successfully the axion related to the trigger' do
        stub_request(:put, "#{Giraffi.endpoint}/triggers/#{@trigger_id}/axions/#{@axion_id}.json?apikey=#{apikey}").
          with(body: {}, query: { axionkind: "recovery" }, headers: Giraffi.request_headers).
          to_return(status: 204, body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_axion_of_trigger(@trigger_id, @axion_id, "recovery")
        assert_equal response.code, 204
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `update_axion_of_trigger` is not 3' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.update_axion_of_trigger(@trigger_id)
        end
      end

      should 'delete successfully the trigger' do
        stub_request(:delete, "#{Giraffi.endpoint}/triggers/#{@trigger_id}.json?apikey=#{apikey}").
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.destroy_trigger(@trigger_id)
        assert response.ok?
        assert response.body == {}
      end

      should 'remove successfully a axion from the trigger' do
        stub_request(:delete, "#{Giraffi.endpoint}/triggers/#{@trigger_id}/axions/#{@axion_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.remove_axion_from_trigger(@trigger_id, @axion_id)
        assert_nothing_raised ArgumentError do
          giraffi.remove_axion_from_trigger(@trigger_id, @axion_id)
        end
        assert response.ok?
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `remove_axion_from_trigger` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.remove_axion_from_trigger(@trigger_id)
        end
      end
    end

  end
end
