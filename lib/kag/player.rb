module KAG
  # https://wiki.kag2d.com/wiki/Player_Info
  class Player
    include HTTParty

    # Public: Returns the String name of the player.
    attr_accessor :kag_name

    # KAG API endpoint.
    base_uri 'http://api.kag2d.com'

    # Public: Initialize a new player.
    #
    # kag_name - The case-insensitive name of the player in King Arthur's Gold
    #            game.
    def initialize(kag_name)
      @kag_name = kag_name
    end

    # Public: Retrieve information about KAG player.
    #
    # force - The flag which enables/disables caching of the info. Being equal
    #         to true, disables caching and resend GET request to KAG API
    #         endpoint (default: false).
    #
    # Examples
    #
    #   player.info
    #   player.info(true) # Disable cached info
    #
    # Returns Hash with info about player or Hash with statusMessage, if the
    # player doesn't exist..
    def info(force = false)
      if force
        @info = get_info
      else
        @info ||= get_info
      end
    end

    # Public: Get the status of the player.
    #
    # Examples
    #
    #   player.active?
    #   # => false
    #
    # Returns true or false.
    def active?
      info['active']
    end

    # Public: Get the username of the player.
    #
    # Examples
    #
    #   player.username
    #   # => 'prostosuper'
    #
    #   # Please, note, that KAG::Player#username is not alias for
    #   # KAG::Player#kag_name. #username is the name, which is given by KAG API
    #   # and #kag_name is an attribute of your object. Feel the difference:
    #   # player = KAG::Player.new('flieslikeabrick')
    #   # player.username
    #   # => 'FliesLikeABrick'
    #   # player.kag_name
    #   # => 'flieslikeabrick'
    #
    # Returns String with containing name of the user in game.
    def username
      info['username']
    end

    # Public: Get the ban status of the player.
    #
    # Examples
    #
    #   player.banned?
    #   # => true
    #
    # Returns true or false.
    def banned?
      info['banned']
    end

    # Public: Returns role of the player.
    #
    # Examples
    #
    #   player.role
    #   # => 4
    #
    # Returns Integer, representing role of the player.
    def role
      info['role']
    end

    # Public: Returns account status of the player. Owners of gold account
    # boughtan the game.
    #
    # Examples
    #
    #   player.gold?
    #   # => false
    def gold?
      info['gold']
    end

    protected

    # Internal: Send GET request to the KAG API endpoint in order to get the
    # information about KAG player.
    #
    # Returns Hash with the information about player or Hash with statusMessage,
    # telling, that player doesn't exist, if there is no KAG player with given
    # username.
    def get_info
      self.class.get "/player/#@kag_name/info"
    end

  end
end
