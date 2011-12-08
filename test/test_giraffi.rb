require 'helper'

class TestGiraffi < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem a wrapper for the Giraffi RESTful" do
    setup do
      @giraffi = Giraffi.new({:apikey => 'wtLTFEqCTX55Lvhtzlqw6doj5xuphemxJa707QXtDPc'})

      @keys = Giraffi::Config::VALID_OPTIONS_KEYS
      @configuration = {
        :request_headers => {
          "User-Agent" => "OreOre Ruby Gem",
          "Accept" => "application/json",
          "Content-Type"  => "application/json"
        },
        :endpoint => "http://tumblr.com/",
        :monitoringdata_endpoint => "http://google.com/",
        :applogs_endpoint => "http://twitter.com",
        :apikey => "donguri"
      }

      @customkey = "26cfa4e2-e493-44d7-8322-4f03b467b412"
      @item_id = 3681
      @service_id = 17972
      @region_code = 'JP'
      @trigger_id = '1151'
      @medium_id = '522'
      @axion_id = '425'
      @trigger_id = '123'

      @item_attrs = {
        name: "Locus Solus",
        host: nil,
        ip: "210.152.137.59",
        normalinterval: "300",
        warninginterval: "180",
        warningretry: "5",
        status: "2",
        customkey: "6f76d596-e4c7-4b54-9afb-e2615c42d1aa"
      }

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

      @medium_attrs = {
        name: "Tweats what happened",
        mediumtype: "twitter"
      }

      @axion_attrs = {
        :name => "Alerting",
        :axiontype => "messaging"
      }

      @applog_attrs = {
        :level => "error",
        :type => "app",
        :time => "1323318027.9443982",
        :message => "Internal Server Error 500"
      }

      @monitoringdata_attrs = {
        :service_id => "17972",
        :servicetype => "load_average",
        :value => "20",
        :tags => ["Testing now", "26cfa4e2-e493-44d7-8322-4f03b467b412"],
        :checked_at => "#{Time.now().to_i}"
      }
    end

    should 'create a new giraffi client via the alias Giraffi.new' do
      giraffi = Giraffi.new({apikey: apikey})
      assert_equal Giraffi::Client, giraffi.class
    end

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

    context 'Testing the API related to the items' do
      should 'return successfully the desired items with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/items.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_items_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_items
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 5
      end

      should 'return successfully the desired item with params' do
        stub_request(:get, "#{Giraffi.endpoint}/items.json?apikey=#{apikey}&customkey=#{@customkey}").
          with(body: {}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_items_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_items({customkey: @customkey})
        assert response.ok?
        assert_equal JSON.parse(response.body)[0]['item']['customkey'], @customkey
      end

      should 'return successfully the desired item by the numerical ID' do
        stub_request(:get, "#{Giraffi.endpoint}/items/#{@item_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_item_by_id.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_item(@item_id)
        assert response.ok?
        assert_equal JSON.parse(response.body)['item']['id'], @item_id
      end

      should 'return the desired agent related to the item' do
        # TODO
      end

      should 'return all services related to the item' do
        stub_request(:get, "#{Giraffi.endpoint}/items/#{@item_id}/services.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_services_by_item_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_services_by_item(@item_id)
        assert response.ok?
        assert_equal @item_id, JSON.parse(response.body)[0]['service']['item_id']
      end

      should 'return a service related to the item with params' do
        stub_request(:get, "#{Giraffi.endpoint}/items/#{@item_id}/services.json?apikey=#{apikey}").
          with(query: {servicetype: "ping"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_service_by_item_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_services_by_item(@item_id, {servicetype: "ping"})
        assert response.ok?
        assert_equal @item_id, JSON.parse(response.body)[0]['service']['item_id']
        assert_equal 'ping', JSON.parse(response.body)[0]['service']['servicetype']
      end

      should 'return no service related to the item with bad params' do
        stub_request(:get, "#{Giraffi.endpoint}/items/#{@item_id}/services.json?apikey=#{apikey}").
          with(query: {servicetype: "http"}, headers: Giraffi.request_headers).
          to_return(body: [])

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_services_by_item(@item_id, {servicetype: "http"})
        assert response.ok?
        assert_equal response.body.size, 0
      end

      should 'create successfully a new item' do
        stub_request(:post, "#{Giraffi.endpoint}/items.json?apikey=#{apikey}").
          with(:query => { :item => @item_attrs } , :headers => Giraffi.request_headers).
          to_return(status: 201, :body => fixture('create_item.json'))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.create_item(@item_attrs)
        assert_equal response.code, 201
        assert_equal JSON.parse(response.body)['item']['name'], 'Locus Solus'
      end

      should 'reload all item' do
        stub_request(:post, "#{Giraffi.endpoint}/items/reload.json?apikey=#{apikey}").
          to_return(body: "\"OK\"")

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.reload_items
        assert response.ok?
        assert_equal response.body, "\"OK\""
      end

      should 'add successfully a service to the item' do
        stub_request(:post, "#{Giraffi.endpoint}/items/#{@item_id}/services.json?apikey=#{apikey}").
          with(:query => { :service => { :servicetype => "applog", :status => "1" }}, :headers => Giraffi.request_headers).
          to_return(:status => 201, :body => fixture('add_service_to_item.json'))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.add_service_to_item(@item_id, {servicetype: "applog", status: "1"})
        assert_equal response.code, 201
        assert_equal JSON.parse(response.body)['service']['item_id'], @item_id
      end

      should 'update successfully the desired item' do
        stub_request(:put, "#{Giraffi.endpoint}/items/#{@item_id}.json?apikey=#{apikey}").
          with(:body => {}, :query => {:item => {:name => "LeRoiUbu"}}, :headers => Giraffi.request_headers).
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_item(3681, {:name => "LeRoiUbu"})
        assert response.ok?
        assert response.body == {}
      end

      should 'delete successfully the item' do
        stub_request(:delete, "#{Giraffi.endpoint}/items/#{@item_id}.json?apikey=#{apikey}").
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.destroy_item(@item_id)
        assert response.ok?
        assert response.body == {}
      end

      should 'remove successfully a service from the item' do
        stub_request(:delete, "#{Giraffi.endpoint}/items/#{@item_id}/services/17972.json?apikey=#{apikey}").
          to_return(:body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.remove_service_from_item(@item_id, @service_id)
        assert_nothing_raised ArgumentError do
          giraffi.remove_service_from_item(@item_id, @service_id)
        end
        assert response.ok?
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `remove_service_from_item` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.remove_service_from_item(@item_id)
        end
      end
    end

    context 'Testing the API related to the services' do
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
        response = giraffi.update_region_by_service(@service_id, 'JP')
        assert_nothing_raised ArgumentError do
          giraffi.update_region_by_service(@service_id, 'JP')
        end
        assert response.ok?
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `update_region_by_service` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.update_region_by_service(@service_id)
        end
      end

      should 'not update the region related to the service with unknown regions code' do
        stub_request(:put, "#{Giraffi.endpoint}/services/#{@service_id}/regions/US.json?apikey=#{apikey}").
          with(:body => {}, headers: Giraffi.request_headers).
          to_return(body: '{"error":"This id is not found."}')

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_region_by_service(@service_id, 'US')
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

    context 'Testing the API related to the media' do
      should 'return successfully the desired media with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/media.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_media_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_media({})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 2
        assert_equal JSON.parse(response.body)[1]['medium']['mediumtype'], "twitter"
      end

      should 'return successfully the desired media with params' do
        stub_request(:get, "#{Giraffi.endpoint}/media.json?apikey=#{apikey}").
          with(body: {}, query: {mediumtype: "twitter"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_media_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_media({mediumtype: "twitter"})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['medium']['mediumtype'], 'twitter'
      end

      should 'return successfully the desired medium by the numerical ID' do
        stub_request(:get, "#{Giraffi.endpoint}/media/#{@medium_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_medium_by_id.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_medium(@medium_id)
        assert response.ok?
        assert_equal JSON.parse(response.body)['medium']['id'], @medium_id.to_i
      end

      should 'redirect successfully to the requested page by the oauth related to the medium' do
        # TODO
      end

      should 'return successfully the oauth-callback related to the medium' do
        # TODO

        #giraffi = Giraffi.new({apikey: apikey})
        #assert_nothing_raised ArgumentError do
        #  giraffi.find_oauth_callback_by_medium(@medium_id, 'oauth_token')
        #end
      end

      should 'raise an error when the number of arguments for `find_oauth_callback` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.find_oauth_callback_by_medium(@medium_id)
        end
      end

      should 'create successfully a new medium' do
        stub_request(:post, "#{Giraffi.endpoint}/media.json?apikey=#{apikey}").
          with(:query => {:medium => @medium_attrs}, headers: Giraffi.request_headers).
          to_return(status: 201, body: fixture("create_medium.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.create_medium(@medium_attrs)
        assert_equal response.code, 201
        assert_equal JSON.parse(response.body)['medium']['name'], "Tweats what happened"
      end

      should 'update successfully the desired medium' do
        stub_request(:put, "#{Giraffi.endpoint}/media/#{@medium_id}.json?apikey=#{apikey}").
          with(:body => {}, :query => {:medium => {:options => {:address => "foo@example.com"}}}, :headers => Giraffi.request_headers).
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_medium(@medium_id, {:options => {:address => "foo@example.com"}})
        assert response.ok?
        #assert response.body == {}
      end

      should 'delete successfully the medium' do
        stub_request(:delete, "#{Giraffi.endpoint}/media/#{@medium_id}?apikey=#{apikey}").
          with(:headers => Giraffi.request_headers).
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.destroy_medium(@medium_id)
        assert response.ok?
        assert response.body == {}
      end
    end

    context 'Testing the API related to the axions' do
      should 'return successfully the desired axions with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/axions.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_axions_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axions
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 4
        assert_equal JSON.parse(response.body)[0]['axion']['axiontype'], "http_request"
      end

      should 'return successfully the desired axions with params' do
        stub_request(:get, "#{Giraffi.endpoint}/axions.json?apikey=#{apikey}").
          with(query: {axiontype: "messaging"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_axions_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axions({axiontype: "messaging"})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['axion']['axiontype'], "messaging"
      end

      should 'return successfully the desired  axion by the numerical ID' do
        stub_request(:get, "#{Giraffi.endpoint}/axions/#{@axion_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: fixture("find_axion_by_id.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_axion(@axion_id)
        assert response.ok?
        assert_equal JSON.parse(response.body)['axion']['id'], @axion_id.to_i
      end

      should 'return successfully the media related to the axion' do
        stub_request(:get, "#{Giraffi.endpoint}/axions/#{@axion_id}/media.json?apikey=#{apikey}").
          with(:query => {name: "Tweat"}, headers: Giraffi.request_headers).
          to_return(body: fixture("find_media_by_axion.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_media_by_axion(@axion_id, {name: "Tweat"})
        assert response.ok?
        assert_equal JSON.parse(response.body)[0]['medium']['name'], "Tweat"
      end

      should 'create successfully a new axion' do
        stub_request(:post, "#{Giraffi.endpoint}/axions.json?apikey=#{apikey}").
          with(:query => {:axion => @axion_attrs}, headers: Giraffi.request_headers).
          to_return(status: 201, body: fixture("create_axion.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.create_axion(@axion_attrs)
        assert_equal response.code, 201
        assert_equal JSON.parse(response.body)['axion']['axiontype'], 'messaging'
      end

      should 'execute successfully the desired axion' do
        stub_request(:post, "#{Giraffi.endpoint}/axions/#{@axion_id}/execute.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(body: "\"OK\"")

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.execute_axion(@axion_id)
        assert response.ok?
        assert_equal response.body, "\"OK\""
      end

      should 'update successfully the desired axion' do
        stub_request(:put, "#{Giraffi.endpoint}/axions/#{@axion_id}.json?apikey=#{apikey}").
          with(:body => {}, :query => {:axion => {:name => "Alerting Neo"}}, headers: Giraffi.request_headers).
          to_return(body: {})
        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.update_axion(@axion_id, {:name => "Alerting Neo"})
        assert response.ok?
        assert response.body == {}
      end

      should 'add successfully the medium to the desired axion' do
        stub_request(:put, "#{Giraffi.endpoint}/axions/#{@axion_id}/media/#{@medium_id}.json?apikey=#{apikey}").
          with(:body => {}, headers: Giraffi.request_headers).
          to_return(:status => 200, :body => {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.add_medium_to_axion(@axion_id, @medium_id)
        assert response.ok?
        assert response.body == {}
        assert_nothing_raised ArgumentError do
          giraffi.add_medium_to_axion(@axion_id, @medium_id)
        end
      end

      should 'raise an error when the number of arguments for `add_medium_to_axion` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.add_medium_to_axion(@axion_id)
        end
      end

      should 'delete successfully the axion' do
        stub_request(:delete, "#{Giraffi.endpoint}/axions/#{@axion_id}?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.destroy_axion(@axion_id)
        assert response.ok?
        assert response.body == {}
      end

      should 'remove successfully a medium from the axion' do
        stub_request(:delete, "#{Giraffi.endpoint}/axions/#{@axion_id}/media/#{@medium_id}.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: {})

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.remove_medium_from_axion(@axion_id, @medium_id)
        assert response.ok?
        assert response.body == {}
        assert_nothing_raised ArgumentError do
          giraffi.remove_medium_from_axion(@axion_id, @medium_id)
        end
      end

      should 'raise an error when the number of argumenrs `remove_medium_from_axion` is not 2' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.remove_medium_from_axion(@axion_id)
        end
      end
    end

    context 'Testing the API related to the triggers' do
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
        response = giraffi.update_axion_by_trigger(@trigger_id, @axion_id, "recovery")
        assert_equal response.code, 204
        assert response.body == {}
      end

      should 'raise an error when the number of arguments for `update_axion_by_trigger` is not 3' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_raise ArgumentError do
          giraffi.update_axion_by_trigger(@trigger_id)
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

    context 'Testing the API related to the applogs' do
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

    context 'Testing the API related to the axion logs' do
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

    context 'Testing the API related to the monitoring data' do
      should 'return successfully the desired monitoring data with no param' do
        stub_request(:get, "#{Giraffi.endpoint}/monitoringdata.json?apikey=#{apikey}").
          with(headers: Giraffi.request_headers).
          to_return(status: 200, body: fixture("find_monitoringdata_with_no_param.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_monitoringdata
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 2
        assert_equal JSON.parse(response.body)[0]['job_id'], "bce29a30-fef0-012e-4b4f-525400011682"
      end

      should 'return successfully the desired monitoring data with params' do
        stub_request(:get, "#{Giraffi.endpoint}/monitoringdata.json?apikey=#{apikey}").
          with(query: {job_id: "e21d3e40-01dd-012f-6bef-5254000ab9a8"}, headers: Giraffi.request_headers).
          to_return(status: 200, body: fixture("find_monitoringdata_with_params.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.find_monitoringdata({job_id: "e21d3e40-01dd-012f-6bef-5254000ab9a8"})
        assert response.ok?
        assert_equal JSON.parse(response.body).size, 1
        assert_equal JSON.parse(response.body)[0]['job_id'], "e21d3e40-01dd-012f-6bef-5254000ab9a8"
      end

      should 'add successfully the monitoring data to the Giraffi' do
        stub_request(:post, "#{Giraffi.monitoringdata_endpoint}/internal/nodelayed?apikey=#{apikey}").
          with(:body => MultiJson.encode({:internal => @monitoringdata_attrs}), headers: Giraffi.request_headers).
          to_return(status: 200, body: fixture("add_monitroingdata.json"))

        giraffi = Giraffi.new({apikey: apikey})
        response = giraffi.add_monitoringdata(@monitoringdata_attrs)
        assert response.ok?
        assert_equal JSON.parse(response.body)['tags'], ["26cfa4e2-e493-44d7-8322-4f03b467b412"]
      end
    end

    context '' do
        #VCR.use_cassette('add_monitroingdata', record: :new_episodes) do
        #  response = @giraffi.add_monitoringdata(@monitoringdata_attrs)
        #  puts response
        #end
    end

  end
end
