require_relative '../../spec_helper'

describe KAG::Player do

  describe 'default instance attributes' do
    let(:player) { KAG::Player.new('prostosuper') }

    before do
      VCR.insert_cassette 'avatar', :record => :none
    end

    after do
      VCR.eject_cassette
    end

    it 'must have an id attribute' do
      player.must_respond_to :nick
    end

    it 'must have the right id' do
      player.nick.must_equal 'prostosuper'
    end

    it 'must have avatar attribute' do
      player.must_respond_to :avatar
    end

    it 'must have the right avatar' do
      player.avatar.small.must_equal 'https://forum.kag2d.com/data/avatars/s/0/231.jpg'
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
      KAG.get('/player/prostosuper/info')
    end

    it 'must have the info method' do
      player.must_respond_to :info
    end

    it 'must parse the API response from JSON to Hash' do
      player.info.must_be_instance_of Hash
    end

    it 'must perform the request and get the info' do
      player.info['username'].must_equal 'prostosuper'
    end

    describe 'JSON player attributes' do
      before do
        player.info
      end

      it 'must return status of the player (active or not)' do
        player.active?.must_equal true
      end

      it 'must return username of the player' do
        player.username.must_equal 'prostosuper'
      end

      it 'must return ban status of the player (banned or not)' do
        player.banned?.must_equal false
      end

      it 'must return account status (gold or not)' do
        player.gold?.must_equal true
      end

      describe 'roles' do

        describe 'normal role' do
          let(:normal) { KAG::Player.new('prostosuper') }

          before do
            VCR.insert_cassette 'normal', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            KAG.get('/player/prostosuper/info')
          end

          it 'must return numeric role of the player' do
            normal.role.must_equal 0
          end

          it 'must return human-readable role of the player' do
            normal.role(true).must_equal 'normal'
          end
        end

        describe 'developer role' do
          let(:developer) { KAG::Player.new('mm') }

          before do
            VCR.insert_cassette 'developer', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            KAG.get('/player/mm/info')
          end

          it 'must return numeric role of the player' do
            developer.role.must_equal 1
          end

          it 'must return human-readable role of the player' do
            developer.role(true).must_equal 'developer'
          end
        end

        describe 'guard role' do
          let(:guard) { KAG::Player.new('dnmr') }

          before do
            VCR.insert_cassette 'guard', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            KAG.get('/player/dnmr/info')
          end

          it 'must return numeric role of the player' do
            guard.role.must_equal 2
          end

          it 'must return human-readable role of the player' do
            guard.role(true).must_equal 'guard'
          end
        end

        # KAG Staff role is undecided:  https://wiki.kag2d.com/wiki/Role
        # describe 'staff role' do
        # end

        describe 'team member role' do
          let(:team_member) { KAG::Player.new('flieslikeabrick') }

          before do
            VCR.insert_cassette 'team_member', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            KAG.get('/player/flieslikeabrick/info')
          end

          it 'must return numeric role of the player' do
            team_member.role.must_equal 4
          end

          it 'must return human-readable role of the player' do
            team_member.role(true).must_equal 'team member'
          end
        end

        describe 'tester role' do
          let(:tester) { KAG::Player.new('incarnum') }

          before do
            VCR.insert_cassette 'tester', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            KAG.get('/player/incarnum/info')
          end

          it 'must return numeric role of the player' do
            tester.role.must_equal 5
          end

          it 'must return human-readable role of the player' do
            tester.role(true).must_equal 'tester'
          end

        end
      end # roles
    end # JSON player attributes

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
