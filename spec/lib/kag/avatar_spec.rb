require_relative '../../spec_helper'

describe KAG::Player::Avatar do

  describe 'GET avatar info' do
    let (:avatar) { KAG::Player::Avatar.new('prostosuper') }

    before do
      VCR.insert_cassette 'avatar', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it 'records the fixture' do
      KAG.get('/player/prostosuper/avatar')
    end

    it 'must have the sizes method' do
      avatar.must_respond_to :sizes
    end

    it 'must parse the API response from JSON to Hash' do
      avatar.sizes.must_be_instance_of Hash
    end

    it 'must perform request and get the small avatar URL' do
      avatar.sizes['small'].must_equal 'https://forum.kag2d.com/data/avatars/s/0/231.jpg'
    end

    it 'must perform request and get the medium avatar URL' do
      avatar.sizes['medium'].must_equal 'https://forum.kag2d.com/data/avatars/m/0/231.jpg'
    end

    it 'must perform request and get the large avatar URL' do
      avatar.sizes['large'].must_equal 'https://forum.kag2d.com/data/avatars/l/0/231.jpg'
    end

    describe 'GET specific avatar sizes' do

      describe 'small size' do
        before do
          VCR.insert_cassette 'avatar_s', :record => :new_episodes
        end

        after do
          VCR.eject_cassette
        end

        it 'records the fixture' do
          KAG.get('/player/prostosuper/avatar/s')
        end

        it 'must retrieve only small avatar size' do
          avatar.small.must_equal 'https://forum.kag2d.com/data/avatars/s/0/231.jpg'
        end
      end

      describe 'medium size' do
        before do
          VCR.insert_cassette 'avatar_m', :record => :new_episodes
        end

        after do
          VCR.eject_cassette
        end

        it 'records the fixture' do
          KAG.get('/player/prostosuper/avatar/m')
        end

        it 'must retrieve only medium avatar size' do
          avatar.medium.must_equal 'https://forum.kag2d.com/data/avatars/m/0/231.jpg'
        end
      end

      describe 'large size' do
        before do
          VCR.insert_cassette 'avatar_l', :record => :new_episodes
        end

        after do
          VCR.eject_cassette
        end

        it 'records the fixture' do
          KAG.get('/player/prostosuper/avatar/l')
        end

        it 'must retrieve only large avatar size' do
          avatar.large.must_equal 'https://forum.kag2d.com/data/avatars/l/0/231.jpg'
        end
      end

    end # GET specific sizes

    describe 'nonexistent avatar nick' do
      let (:avatar) { KAG::Player::Avatar.new('foobarbazbaz') }

      it 'must return statusMessage telling that player not found' do
        not_found_message = 'Player not found'

        avatar.small['statusMessage'].must_equal  not_found_message
        avatar.medium['statusMessage'].must_equal not_found_message
        avatar.large['statusMessage'].must_equal  not_found_message
        avatar.sizes['statusMessage'].must_equal  not_found_message

        avatar.sizes['small'].must_be_nil
        avatar.sizes['medium'].must_be_nil
        avatar.sizes['large'].must_be_nil
      end
    end

    describe 'caching' do
      before do
        avatar.sizes
        stub_request(:any, /api.kag2d.com/).to_timeout
      end

      it 'must cache sizes' do
        avatar.sizes.must_be_instance_of Hash
      end

      it 'must refresh sizes if forced' do
        lambda { avatar.sizes(true) }.must_raise Timeout::Error
      end
    end


  end # GET avatar info

end
