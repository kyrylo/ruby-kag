require_relative '../../spec_helper'

describe KAG do

  describe 'default attributes' do
    it 'must include HTTPparty methods' do
      KAG.must_include HTTParty
    end

    it 'must have the base URL set to the KAG API' do
      KAG.base_uri.must_equal 'http://api.kag2d.com'
    end
  end

end
