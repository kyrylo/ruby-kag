require_relative '../../spec_helper'

describe KAG::Player do

  describe 'default attributes' do
    it 'must include HTTPparty methods' do
      KAG::Player.must_include HTTParty
    end

    it 'must have the base URL set to the KAG API endpoint' do
      KAG::Player.base_uri.must_equal 'http://api.kag2d.com'
    end
  end

  describe 'default instance attributes' do
    let(:player) { KAG::Player.new('prostosuper') }

    it 'must have an id attribute' do
      player.must_respond_to :username
    end

    it 'must have the right id' do
      player.username.must_equal 'prostosuper'
    end
  end

  describe 'GET info' do
    let (:player) { KAG::Player.new('prostosuper') }

    before do
      VCR.insert_cassette 'player', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it 'records the fixture' do
      KAG::Player.get('/player/prostosuper/info')
    end

    it 'must have an info method' do
      player.must_respond_to :info
    end

    it 'must parse the API response from JSON to Hash' do
      player.info.must_be_instance_of Hash
    end

    it 'must perform the request and get the info' do
      player.info['username'].must_equal 'prostosuper'
    end

    describe 'dynamic attributes' do
      before do
        player.info
      end

      it 'must return the attribute value if present in info' do
        player.gold.must_equal true
      end

      it 'must raise method missing if attribute is not present' do
        lambda { player.foo_attribute }.must_raise NoMethodError
      end
    end

    describe 'caching' do
      before do
        player.info
        stub_request(:any, /api.kag2d.com/).to_timeout
      end

      it 'must cache the info' do
        player.info.must_be_instance_of Hash
      end

      it 'must refresh the info if forced' do
        lambda { player.info(true) }.must_raise Timeout::Error
      end
    end
  end

end
