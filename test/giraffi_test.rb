require 'test_helper'

class GiraffiTest < Test::Unit::TestCase
  context 'Testing the Ruby Gem for the Giraffi RESTful API' do

    context 'about the module `giraffi`' do
      should 'create a new giraffi client via the alias Giraffi.new' do
        giraffi = Giraffi.new({apikey: apikey})
        assert_equal Giraffi::Client, giraffi.class
      end
    end

  end
end
