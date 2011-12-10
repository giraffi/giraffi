require 'test_helper'

class MonitoringdataTest < Test::Unit::TestCase
  context "Testing Giraffi Ruby Gem for the Giraffi RESTful API" do
    setup do
      @monitoringdata_attrs = {
        :service_id => "17972",
        :servicetype => "load_average",
        :value => "20",
        :tags => ["Testing now", "26cfa4e2-e493-44d7-8322-4f03b467b412"],
        :checked_at => "#{Time.now().to_i}"
      }
    end

    context 'about the API related to the monitoring data' do
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

  end
end
