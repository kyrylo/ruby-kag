require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

require_relative '../lib/kag'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/kag_cassettes'
  c.hook_into :webmock
end
