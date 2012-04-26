module KAG
  # https://wiki.kag2d.com/wiki/Avatar_URL
  class Player::Avatar
    # Public: Initialize a new avatar.
    #
    # nick - The case-insensitive name of the avatar owner.
    def initialize(nick)
      @nick = nick
    end

    # Public: Retrieve avatar information about KAG player.
    #
    # force - The flag which enables/disables caching of the avatars. Being
    #         equal to true, disables caching and resend GET request to KAG API
    #         endpoint (default: false).
    #
    # Returns Hash with avatar sizes of the player or Hash with statusMessage,
    # if the player doesn't exist.
    def sizes(force = false)
      if force
        @sizes = get_avatar
      else
        @sizes ||= get_avatar
      end
    end

    # Internal: Intercepts all method calls on instances of this class, that
    # aren't defined here. If the called method coincides with one of the valid
    # methods, then it gets the value of that Hash pair from @sizes Hash. If
    # the parameter true was provided, then the method performs a request
    # directly to API rather than to cache.
    #
    # force - If equals to true, then request an avatar from API. If false, then
    #         use avatar from cache (default: false).
    #
    # Examples
    #
    #   avatar.foo_bar_baz
    #   # => NoMethodError
    #   avatar.small
    #   # => "https://forum.kag2d.com/data/avatars/s/0/231.jpg"
    #
    #   # From cache.
    #   avatar.small
    #   # => "https://forum.kag2d.com/data/avatars/s/0/231.jpg"
    #
    #   # Refresh cache.
    #   avatar.small(true)
    #   # => "https://forum.kag2d.com/data/avatars/s/0/231.jpg"
    #
    #   # Attempt to get an avatar of nonexistent player.
    #   nonexistent_avatar = KAG::Player::Avatar.new('foobarbazbaz')
    #   nonexistent_avatar.small
    #   # => {"statusMessage"=>"Player not found"}
    #
    # Returns the value of the method call on self.
    # Raises NoMethodError, if the given method doesn't exist.
    def method_missing(m, *args, &block)
      valid_method = [:small, :medium, :large].find { |size| size === m }

      if valid_method
        if args[0] === true
          send("get_#{m}_avatar")
        else
          sizes.fetch(m.to_s) { sizes }
        end
      else
        super
      end
    end

    protected

    # Internal: Send GET request to the KAG API endpoint in order to get
    # player's avatars (small, medium, large).
    #
    # Returns Hash with the information about avatars or Hash with
    # statusMessage, telling, that player doesn't exist, if there is no KAG
    # player with given nick.
    def get_avatar
      KAG.get "/player/#@nick/avatar"
    end

    # Internal: Send GET request to the KAG API endpoint in order to get
    # player's small avatar.
    #
    # Returns Hash with the information about avatars or Hash with
    # statusMessage, telling, that player doesn't exist, if there is no KAG
    # player with given nick.
    def get_small_avatar
      KAG.get "/player/#@nick/avatar/s"
    end

    # Internal: Send GET request to the KAG API endpoint in order to get
    # player's medium avatar.
    #
    # Returns Hash with the information about avatars or Hash with
    # statusMessage, telling, that player doesn't exist, if there is no KAG
    # player with given nick.
    def get_medium_avatar
      KAG.get "/player/#@nick/avatar/m"
    end

    # Internal: Send GET request to the KAG API endpoint in order to get
    # player's large avatar.
    #
    # Returns Hash with the information about avatars or Hash with
    # statusMessage, telling, that player doesn't exist, if there is no KAG
    # player with given nick.
    def get_large_avatar
      KAG.get "/player/#@nick/avatar/l"
    end

  end
end
