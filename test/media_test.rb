require 'test_helper'

class MediaTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @medium_id = '522'
      @medium_attrs = {
        name: "Tweats what happened",
        mediumtype: "twitter"
      }
    end

    context 'about the API related to the media' do
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
        assert response.body == {}
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

  end
end
