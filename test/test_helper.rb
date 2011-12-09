require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'json'
require 'shoulda'
require 'webmock/test_unit'
require 'vcr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# VCR that records the test suite's HTTP interactions and replay them
VCR.config do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.stub_with :webmock
end

require 'giraffi'

def fixture(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def apikey
  'test_key'
end

class Test::Unit::TestCase
end
