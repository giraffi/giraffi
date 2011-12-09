require 'test_helper'

class ItemsTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful" do
    setup do

      @customkey = "26cfa4e2-e493-44d7-8322-4f03b467b412"
      @item_id = 3681
      @service_id = 17972

      @item_attrs = {
        name: "Locus Solus",
        host: nil,
        ip: "127.0.0.59",
        normalinterval: "300",
        warninginterval: "180",
        warningretry: "5",
        status: "2",
        customkey: "6f76d596-e4c7-4b54-9afb-e2615c42d1aa"
      }
    end

    context 'about the API related to the items' do
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

  end
end
