module KAG
  # https://wiki.kag2d.com/wiki/Player_Info
  class Player
    # Public: Returns the String name of the player.
    attr_reader :nick

    # Public: Returns the KAG::Player::Avatar object.
    attr_reader :avatar

    # Public: Initialize a new player.
    #
    # nick - The case-insensitive name of the player in King Arthur's Gold game.
    def initialize(nick)
      @nick   = nick
      @avatar = Avatar.new(nick)
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
    #   # KAG::Player#nick. KAG::Player#username is the name, which is given by
    #   # KAG API and Player#nick is an attribute of your object. Feel the
    #   # difference:
    #   # player = KAG::Player.new('flieslikeabrick')
    #   # player.username
    #   # => 'FliesLikeABrick'
    #   # player.nick
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
    # readable - The Boolean flag, which describes how the return value should
    #            be represented (either machine-readable format or
    #            human-readable) (default: false).
    #
    # Examples
    #
    #   # Machine-readable role.
    #   player.role
    #   # => 4
    #
    #   # Human-readable role.
    #   player.role(true)
    #   # => 'team member'
    #
    # Returns Integer, representing role of the player or String, if readable
    # flag was used.
    def role(readable = false)
      role = info['role']

      if readable
        case role
        when 0 then 'normal'
        when 1 then 'developer'
        when 2 then 'guard'
        when 4 then 'team member'
        when 5 then 'tester'
        end
      else
        role
      end
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
    # nick.
    def get_info
      KAG.get "/player/#@nick/info"
    end

  end
end
