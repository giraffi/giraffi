require 'test_helper'

class AxionsTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @medium_id = '522'
      @axion_id = '425'

      @axion_attrs = {
        :name => "Alerting",
        :axiontype => "messaging"
      }
    end

    context 'about the API related to the axions' do
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

  end
end
